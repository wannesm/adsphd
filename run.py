#!/usr/bin/env python3
# encoding: utf-8
#
# Copyright (C), 2012-2025 by Wannes Meert, KU Leuven
#
# Very naive compilation script for the ADSPHD class.
#
# No file dependency checks are performed (use TeXnicCenter, Texmaker, latexmk,
# rubber, SCons, or make if you want such a feature).
#

import re
import shlex
import sys
import argparse
from collections import namedtuple
from pathlib import Path

from subprocess import *

## SETTINGS ##

given_settings = {
  'mainfile':    'thesis.tex',
  'chaptersdir': 'chapters',

  'makebibliography': True,
  'makeindex':        True,
  'makeglossary':     True,
  'makenomenclature': True,

  'usebiblatex':      False,
  'biblatexbackend':  'biber', # alternative: bibtex

  'cleanext':         ['.tdo','.fls','.toc','.aux','.log','.bbl','.blg','.log',
                       '.lof','.lot','.ilg','.out','.glo','.gls','.nlo','.nls',
                       '.brf','.ist','.glg','.synctexgz','.tgz','.idx','.ind',
                       '-blx.bib','.fdb_latexmk','.synctex.gz','.run.xml',
                       '.bcf','.glsdefs','.xdy']
}

derived_settings = ['basename', 'chapters', 'cleanfiles', 'pdffile']

verbose          = 0
dry              = False


### INITIALISATION ###

def initapplications(use_lualatex=False):
	"""Initialize the application commands and arguments for the different
	   platforms."""
	global apps
	# Unix and linux are the default setup
	## *NIX ##
	apps.pdflatex     = App('pdflatex',  '-interaction=nonstopmode -synctex=1 -shell-escape {basename}', verbose)
	apps.bibtex       = App('bibtex',    '-min-crossrefs=100 {basename}', verbose)
	apps.biber        = App('biber',     '{basename}', verbose)
	apps.glossary     = App('makeindex', '{basename}.glo -s {basename}.ist -o {basename}.gls', verbose)
	apps.nomenclature = App('makeindex', '{basename}.nlo -s nomencl.ist -o {basename}.nls', verbose)
	apps.pdfviewer    = App('acroread',  '{pdffile}', verbose)

	if sys.platform == 'darwin':
		## Mac OS X ##
		apps.pdfviewer   = App('open',      '{pdffile}', verbose)

	elif sys.platform == 'win32' or sys.platform == 'cygwin':
		## Windows ##
		pass

	if use_lualatex:
		apps.pdflatex = App('lualatex',  '-interaction=nonstopmode -synctex=1 -shell-escape {basename}', verbose)


## DERIVED SETTINGS ##

def create(*args, **kwargs):
    class DictAsObj():
        def __init__(self, *args, **kwargs):
            self.__dict__ = kwargs
            for arg in args:
                self.__dict__[arg] = None
        def __iter__(self):
            return self.__dict__.items().__iter__()
        def items(self):
            return dict(self.__dict__.items())
        def copy(self):
            return DictAsObj(**self.__dict__)
    return DictAsObj(*args, **kwargs)

settings = create(*derived_settings, **given_settings)

settings.basename = Path(settings.mainfile).with_suffix('')
settings.chapters = [chap.with_suffix('') for chap in Path(settings.chaptersdir).glob('**/*.tex')]
settings.cleanfiles = [base.with_name(base.stem + ext) for ext in settings.cleanext for base in [settings.basename, Path('cover')]+settings.chapters]
settings.pdffile = settings.basename.with_suffix('.pdf')

apps = create('pdflatex', 'bibtex', 'biber', 'glossary', 'nomenclature', 'pdfviewer', 'remove')

## COMPILE ##

knowntargets = dict()

def target(targetname = None):
	def decorate(f):
		global knowntargets
		name = targetname if targetname else f.__name__
		knowntargets[name] = f
		return f
	return decorate


## TARGETS ##

@target()
def test():
    """Verify the settings in run.py"""
    allok = testSettings()
    if allok:
        print("Your settings appear to be consistent")
    if verbose > 0:
        for k,v in settings:
            if verbose > 1 or k not in ['cleanfiles']:
                print("{}: {}".format(k, v))
    else:
        print("(use -v to inspect).")

@target()
def pdf():
    """Alias for compile"""
    return compile()

@target()
def compile():
	"""Build thesis.pdf"""
	testSettings()
	latex()


def latex():
	global apps
	rerun = False
	print('#### LATEX ####')
	apps.pdflatex.run(settings, 'Latex failed')
	if settings.makebibliography:
		rerun = True
		if settings.usebiblatex and settings.biblatexbackend == 'biber':
			print('#### BIBER ####')
			apps.biber.run(settings, 'Biber failed')
		else:
			print('#### BIBTEX ####')
			apps.bibtex.run(settings, 'Bibtex failed')
	if settings.makeindex:
		rerun = True
		print('#### INDEX ####')
	if settings.makeglossary:
		# List of abbreviations
		rerun = True
		print('#### GLOSSARY ####')
		apps.glossary.run(settings, 'Creating glossary failed')
	if settings.makenomenclature:
		# List of symbols
		rerun = True
		print('#### NOMENCLATURE ####')
		apps.nomenclature.run(settings, 'Creating glossary failed')
	if rerun:
		print('#### LATEX ####')
		apps.pdflatex.run(settings, 'Rerunning (1) Latex failed')
		print('#### LATEX ####')
		apps.pdflatex.run(settings, 'Rerunning (2) Latex failed')


@target()
def clean():
	"""Remove the auxiliary files created by Latex."""
	rm(settings.cleanfiles, 'Removing auxiliary files failed')


@target()
def realclean():
	"""Remove all files created by Latex."""
	clean()
	cleanfiles = [
		Path('thesis.pdf'), Path('thesis.dvi'), Path('thesis.ps'),
		Path('cover.pdf'), Path('cover.dvi'), Path('cover.ps')
	]
	rm(cleanfiles, 'Removing pdf files failed')

@target()
def cover():
    """Generate a cover.tex file and produce a standalone cover.pdf"""

    usersettings = dict()
    doc_re = re.compile(r"^\\documentclass")
    settings_re = [
        ('faculty', re.compile("faculty=([a-z]+)")),
        ('department', re.compile("department=([a-z]+)")),
        ('phddegree', re.compile("phddegree=([a-z]+)"))
    ]

    content = []
    doadd = False
    with open(settings.mainfile,'r') as mf:
        for line in mf:
            if "documentclass" in line:
                if doc_re.match(line) is not None:
                    for s, r in settings_re:
                        result = r.search(line)
                        if result is not None:
                            usersettings[s] = result.group(1)
            if doadd:
                content.append(line)
            if "%%% COVER: Settings" in line:
                doadd = True
            elif "%%% COVER: End" in line:
                doadd = False
    if verbose > 0:
        print('Recovered settings: ')
        print(usersettings)
    extra_usersettings = ','.join(['']+['{}={}'.format(k,v) for k,v in usersettings.items()])

    with open('cover.tex','w') as cf:
        cf.write("""% Cover.tex
\\documentclass[cam,cover{}]{{adsphd}}""".format(extra_usersettings))
        cf.write("""
\\usepackage{printlen}
\\uselengthunit{mm}
\\IfFileExists{tikz}{\\usepackage{tikz}\\usetikzlibrary {arrows.meta}}{}
""")
        cf.write("".join(content))
        cf.write("""
% Compute total page width
\\newlength{\\fullpagewidth}
\\setlength{\\fullpagewidth}{2\\adsphdpaperwidth}
\\addtolength{\\fullpagewidth}{2\\defaultlbleed}
\\addtolength{\\fullpagewidth}{2\\defaultrbleed}
\\addtolength{\\fullpagewidth}{\\adsphdspinewidth}
% Compute total page height
\\newlength{\\fullpageheight}
\\setlength{\\fullpageheight}{\\adsphdpaperheight}
\\addtolength{\\fullpageheight}{\\defaulttbleed}
\\addtolength{\\fullpageheight}{\\defaultbbleed}

\\geometry{
	paperwidth=\\fullpagewidth,
	paperheight=\\fullpageheight,
}

\\pagestyle{empty}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\\begin{document}

\\makefullcoverpage{\\adsphdspinewidth}{}

\\mbox{}
\\newpage
\\subsection*{Used settings:}
\\begin{itemize}
	\\item Spine width: \\printlength{\\adsphdspinewidth}
	\\item Left bleed: \\printlength{\\lbleed} (bleed into spine)
	\\item Right bleed: \\printlength{\\rbleed} (bleed over edge of paper)
	\\item Top bleed: \\printlength{\\tbleed}
	\\item Bottom bleed: \\printlength{\\bbleed}
	\\item Paper width: \\printlength{\\adsphdpaperwidth}
	\\item Paper height: \\printlength{\\adsphdpaperheight}
	\\item Text width: \\printlength{\\textwidth}
	\\item Text height: \\printlength{\\textheight}
\\end{itemize}

\\drawextracroplines
\\drawextracroplinesexplanation

\\end{document}
""")

    print("Written cover to cover.tex")
    newsettings = settings.copy()
    newsettings.basename = 'cover'
    apps.pdflatex.run(newsettings, 'Running Latex failed')


@target()
def newchapter():
	"""Create the necessary files for a new chapter."""
	chaptername = ""
	validchaptername = re.compile(r'^[a-zA-Z0-9_.]+$')
	while validchaptername.match(chaptername) == None:
		chaptername = input("New chapter file name (only a-z, A-Z, 0-9 or _): ")
	newdir = Path(settings.chaptersdir, chaptername)
	print(f"Creating new directory: {newdir}")
	newdir.mkdir(parents=True, exist_ok=True)
	newfile = newdir / f"{chaptername}.tex"
	print(f"Creating new tex-file: {newfile}")
	with open(newfile, 'w') as f:
		f.write("% !TeX root = ../../"+settings.mainfile)
		f.write("\n\\chapter{This is "+chaptername+"}\\label{ch:"+chaptername+"}\n")
		f.write("\n\\ldots\n\n\n\n\
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\
% Keep the following \\cleardoublepage at the end of this file, \n\
% otherwise \\includeonly includes empty pages.\n\
\\cleardoublepage\n")

@target()
def view():
	"""Open the generated pdf file in a pdf viewer."""
	print("Opening "+settings.pdffile)
	apps.pdfviewer.run(settings, 'Opening pdf failed.')

@target()
def targets():
	"""Print overview of available targets."""
	print("Targets:")
	targetdocs = [(target,f.__doc__) for (target,f) in  knowntargets.items()]
	maxl = max((len(t) for (t,d) in targetdocs))
	targetdocs.sort()
	for (target,doc) in targetdocs:
		s = "- {:<"+str(maxl)+"}   {}"
		if doc == None:
			doc = ''
		print(s.format(target,doc))

## AUXILIARY ##

def testSettings():
	"""Verify whether run.py is using the expected settings based on
	   thesis.tex.
	"""
	allok = True
	allok = allok and testBiblatex()
	allok = allok and testNomenclature()
	allok = allok and testGlossary()
	return allok


def testBiblatex():
	"""Test whether the main tex file includes biblatex and if this is
	   consistent with the settings in run.py
	"""
	global usebiblatex
	allok = True
	isusingbiblatex = False
	# pattern = re.compile(r'^\\documentclass.*biblatex*.*$')
	pattern = re.compile(r'^\s*[^%].*{biblatex}')
	with open(settings.mainfile, 'r') as f:
		for line in f:
			if pattern.search(line) != None:
				isusingbiblatex = True
				if not settings.usebiblatex:
					print("WARNING: It appears you are using biblatex while this setting in run.py is set to false.\n")
					allok = False
					# settings.usebiblatex = True
					return allok
	if not isusingbiblatex and settings.usebiblatex:
		print("WARNING: It appears you are not using biblatex while this setting in run.py is set to true.\n")
		# settings.usebiblatex = False
		allok = False
	return allok


def testNomenclature():
	"""Check whether the nomenclature settings are consistent."""
	allok = True
	pattern = re.compile(r'^\s*\\usepackage.*{nomencl}.*')
	found = False
	with open(settings.mainfile, 'r') as texfile:
		for line in texfile:
			if pattern.search(line) != None:
				found = True
	if not found and settings.makenomenclature:
		print("\nWARNING: Trying to build the nomenclature but you have not include the nomencl Latex package.\n")
		allok = False
	if found and not settings.makenomenclature:
		print("\nWARNING: You have included the nomencl Latex package but in the run.py script this step is not activated.\n")
		allok = False
	return allok


def testGlossary():
	"""Check whether the glossaries settings are consistent."""
	allok = True
	pattern = re.compile(r'^\s*\\usepackage.*{glossaries.*')
	found = False
	with open(settings.mainfile, 'r') as texfile:
		for line in texfile:
			if pattern.search(line) != None:
				found = True
	if not found and settings.makeglossary:
		print("\nWARNING: Trying to build the glossary but you have not include the glossaries Latex package.\n")
		allok = False
	if found and not settings.makeglossary:
		print("\nWARNING: You have included the glossary Latex package but in the run.py script this step is not activated.\n")
		allok = False
	return allok


def rm(files, errmsg):
	# Cross-platform "rm -f [files]"
	for file in files:
		try:
			# file.unlink(missing_ok=True)  # Python >= 3.8
			file.unlink()
		except FileNotFoundError:
			pass
		except OSError as err:
			print(err)
			print(sys.argv[0].split("/")[-1] + ": "+errmsg+" (exitcode "+str(err.returncode)+")", file=sys.stderr)
			sys.exit(1)


## APPLICATION ##

class App:
	def __init__(self, b, o, v=0):
		self.binary = b
		self.options = o
		self.verbose = v

	def run(self, settings, errmsg):
		""" Run the command for the given settings.
			Required settings:
				- basename
				- pdffile
		
			:returns: Return code
		"""
		returncode = 1
		try:
			cmd = self.options.format(**settings.items())
			if sys.platform == "win32":
				args = self.binary + " " + cmd
				print(f"Running: {args}")
			else:
				args = [self.binary] + shlex.split(cmd)
				print("Running: " + " ".join(args))
			if not dry:
				returncode = check_call(args)
		except CalledProcessError as err:
			print(err)
			print(sys.argv[0].split("/")[-1] + ": "+errmsg+" (exitcode "+str(err.returncode)+")", file=sys.stderr)
			sys.exit(1)
		return returncode

## COMMAND LINE INTERFACE ##

class Usage(Exception):
	def __init__(self, msg):
		self.msg = msg

def main(argv=None):
	global verbose
	global dry

	parser = argparse.ArgumentParser(
		    description='''
Naive compilation script for the ADSPhD class. No file dependency checks
are performed. Use TeXnicCenter, Texmaker, latexmk, rubber, SCons or
make for such a feature.''',
		    epilog='''
Settings: Open run.py with a text editor and change values in the settings 
definition
		    ''')
	parser.add_argument('--verbose', '-v', action='count',      help='Verbose output')
	parser.add_argument('--targets', '-T', action='store_true', help='Print available targets')
	parser.add_argument('--dry', '-d',     action='store_true', help='Dry run to see commands without executing them')
	parser.add_argument('--lua',           action='store_true', help='Use LuaLaTeX instead of pdflatex')
	parser.add_argument('target',          nargs='*',           help='Targets')

	args = parser.parse_args(argv)

	if args.verbose is not None:
		verbose = args.verbose
	dry = args.dry

	if args.targets:
		targets()
		return

	initapplications(use_lualatex=args.lua)
	
	if len(args.target) == 0:
		print("No targets given, using default target: compile")
		compile()

	for target in args.target:
		print("Target: "+target)
		if target in knowntargets:
			knowntargets[target]()
		else:
			print("Unknown target")
	


if __name__ == "__main__":
	sys.exit(main())

