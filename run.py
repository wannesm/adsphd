#!/usr/bin/env python3
# encoding: utf-8
#
# Copyright (C), 2012-2026 by Wannes Meert, KU Leuven
#
# Cross-platform helper script for the ADSPHD class. Compilation is delegated
# to latexmk, which reads .latexmkrc; this script adds the project chores.
#

import os
import re
import shlex
import shutil
import sys
import argparse
from pathlib import Path

from subprocess import *

## SETTINGS ##

given_settings = {
  'mainfile':    'thesis.tex',
  'chaptersdir': 'chapters',

  'cleanext':         ['.tdo','.fls','.toc','.aux','.log','.bbl','.blg','.log',
                       '.lof','.lot','.ilg','.out','.glo','.gls','.nlo','.nls',
                       '.brf','.ist','.glg','.synctexgz','.tgz','.idx','.ind',
                       '-blx.bib','.fdb_latexmk','.synctex.gz','.run.xml',
                       '.bcf','.glsdefs','.xdy'],
  'ignore_errors':     False,
}

derived_settings = ['basename', 'chapters', 'cleanfiles', 'pdffile']

verbose          = 0
dry              = False

# Stripped from the temporary main file for a chapter build.
# Kept in sync with IGNOREINCHAPTERMODE in the Makefile.
CHAPTER_ONLY_IGNORE = ['makefrontcover', 'makebackcover', 'tableofcontents',
                       'includebibliography', 'maketitle', 'listoffigures',
                       'listoftables', 'printnomenclature', 'printglossary',
                       'includeonly', 'instructionschapters']


### INITIALISATION ###

def initapplications(use_lualatex=False):
	"""Initialize the application commands and arguments for the different
	   platforms."""
	global apps
	engineflag = '-pdflua' if use_lualatex else '-pdf'
	apps.latexmk = App('latexmk',
	                   engineflag + ' -interaction=nonstopmode -halt-on-error'
	                   ' -file-line-error -shell-escape {basename}', verbose)

	if sys.platform == 'darwin':
		apps.pdfviewer = App('open',      '{pdffile}', verbose)
	elif sys.platform in ('win32', 'cygwin'):
		apps.pdfviewer = None          # handled by os.startfile in view()
	else:
		apps.pdfviewer = App('xdg-open', '{pdffile}', verbose)


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

apps = create('latexmk', 'pdfviewer')

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
	"""Check that the toolchain and the project files are in place."""
	allok = True
	if shutil.which('latexmk') is None:
		print("ERROR: latexmk was not found on your PATH. It is part of both "
		      "TeX Live and MiKTeX.")
		allok = False
	if not Path(settings.mainfile).is_file():
		print(f"ERROR: main file {settings.mainfile} not found.")
		allok = False
	if not Path('.latexmkrc').is_file():
		print("WARNING: no .latexmkrc found; latexmk will use its defaults, "
		      "which do not know about glossaries and nomencl.")
	if not Path(settings.chaptersdir).is_dir():
		print(f"WARNING: no {settings.chaptersdir}/ directory found.")
	if allok:
		print("Your setup appears to be complete")
	if verbose > 0:
		for k, v in settings:
			if verbose > 1 or k not in ['cleanfiles']:
				print("{}: {}".format(k, v))
	else:
		print("(use -v to inspect).")
	return allok


@target()
def pdf():
	"""Alias for compile"""
	return compile()


@target()
def compile():
	"""Build the full thesis pdf"""
	print('#### LATEXMK ####')
	apps.latexmk.run(settings, 'Latexmk failed')


@target()
def chapter():
	"""Build a single chapter (use --chapter NAME)"""
	name = settings.chapter
	if name is None:
		print("No chapter given. Use --chapter NAME, where NAME is one of:")
		for d in sorted(Path(settings.chaptersdir).iterdir()):
			if d.is_dir():
				print("  " + d.name)
		return 1

	chapterdir = Path(settings.chaptersdir, name)
	if not chapterdir.is_dir():
		print(f"ERROR: no such chapter directory: {chapterdir}")
		return 1

	jobname = f"{settings.basename}_{name}_ch"
	tmpmain = Path(f"{settings.basename}_ch.tex")
	includeonly = (Path(settings.chaptersdir) / name / name).as_posix()

	# Substring match like the Makefile's grep: \makefrontcoverXXIV must
	# match \makefrontcover, so no word boundary here.
	ignore_re = re.compile(r'\\(' + '|'.join(CHAPTER_ONLY_IGNORE) + r')')
	lines = []
	with open(settings.mainfile, 'r') as f:
		for line in f:
			if ignore_re.search(line):
				continue
			if '\\begin{document}' in line:
				line = line.replace('\\begin{document}',
				                    '\\includeonly{' + includeonly + '}\n\\begin{document}')
			lines.append(line)

	print(f"Writing temporary main file {tmpmain}")
	if not dry:
		with open(tmpmain, 'w') as f:
			f.writelines(lines)

	# Reuse the full document's aux files so cross-references resolve.
	for ext in ['.aux', '.bbl', '.nls', '.gls']:
		src = Path(f"{settings.basename}{ext}")
		if src.is_file():
			print(f"Reusing {src}")
			if not dry:
				shutil.copyfile(src, Path(f"{jobname}{ext}"))

	print('#### LATEXMK ####')
	newsettings = settings.copy()
	newsettings.basename = str(tmpmain.with_suffix(''))
	chapterapp = App(apps.latexmk.binary,
	                 apps.latexmk.options.replace('{basename}',
	                                              f'-jobname={jobname} {{basename}}'),
	                 verbose)
	chapterapp.run(newsettings, 'Latexmk failed')

	result = Path(f"{jobname}.pdf")
	target_pdf = chapterdir / f"{name}.pdf"
	if result.is_file() or dry:
		print(f"Moving {result} to {target_pdf}")
		if not dry:
			shutil.move(str(result), str(target_pdf))
	if not dry:
		tmpmain.unlink(missing_ok=True)
		rm([Path(f"{jobname}{ext}") for ext in settings.cleanext], 'Cleaning up failed')
	return 0


@target()
def clean():
	"""Remove the auxiliary files created by Latex."""
	rm(settings.cleanfiles, 'Removing auxiliary files failed')


@target()
def realclean():
	"""Remove all files created by Latex."""
	clean()
	cleanfiles = [settings.basename.with_suffix('.pdf'),
	              Path('cover.pdf'), Path('cover.tex')]
	chaptersdir = Path(settings.chaptersdir)
	if chaptersdir.is_dir():
		cleanfiles += [chaptersdir / d.name / (d.name + '.pdf')
		               for d in chaptersdir.iterdir() if d.is_dir()]
	rm(cleanfiles, 'Removing pdf files failed')


@target()
def cover():
    """Generate a cover.tex file and produce a standalone cover.pdf"""

    usersettings = dict()
    doc_re = re.compile(r"^\\documentclass")
    settings_re = [
        ('faculty', re.compile("faculty=([a-z]+)")),
        ('doctoralschool', re.compile("doctoralschool=([a-z]+)")),
        ('department', re.compile("department=([a-z]+)")),
        ('phddegree', re.compile("phddegree=([a-z]+)")),
        ('coverfontpercent', re.compile("coverfontpercent=([a-z]+)")),
        ('british', re.compile("british")),
        ('helveticaneue', re.compile("helveticaneue")),
        ('joint', re.compile("joint")),
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
                            if len(result.groups()) > 0:
                                usersettings[s] = result.group(1)
                            else:
                                usersettings[s] = None
            if doadd:
                content.append(line)
            if "%%% COVER: Settings" in line:
                doadd = True
            elif "%%% COVER: End" in line:
                doadd = False
    if verbose > 0:
        print('Recovered settings: ')
        print(usersettings)
    extra_usersettings = []
    for k,v in usersettings.items():
        if v is None:
            extra_usersettings.append(k)
        else:
            extra_usersettings.append('{}={}'.format(k,v))
    extra_usersettings = ','.join(['']+extra_usersettings)

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
    apps.latexmk.run(newsettings, 'Running latexmk on the cover failed')


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
	if not Path(settings.pdffile).is_file():
		print(f"No {settings.pdffile} found. Build it first with: python run.py")
		return 1
	print("Opening " + str(settings.pdffile))
	if apps.pdfviewer is None:
		if not dry:
			os.startfile(str(settings.pdffile))  # noqa: S606
		else:
			print(f"Running: start {settings.pdffile}")
	else:
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

def rm(files, errmsg):
	# Cross-platform "rm -f [files]"
	for file in files:
		if dry:
			print(f"Removing: {file}")
			continue
		try:
			file.unlink()
		except FileNotFoundError:
			pass
		except OSError as err:
			print(err)
			print(sys.argv[0].split("/")[-1] + ": "+errmsg, file=sys.stderr)
			sys.exit(1)


## APPLICATION ##

class App:
	def __init__(self, b, o, v=0):
		self.binary = b
		self.options = o
		self.verbose = v

	def run(self, settings, errmsg):
		"""Run the command, formatted with the given settings."""
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
			if not settings.ignore_errors:
				sys.exit(1)
		return returncode


## COMMAND LINE INTERFACE ##

def main(argv=None):
	global verbose
	global dry

	parser = argparse.ArgumentParser(
		    description='''
Helper script for the ADSPhD class. Compilation is delegated to latexmk,
which reads .latexmkrc and handles reruns, bibtex/biber, glossaries and
nomencl by itself.''',
		    epilog='''
Settings: Open run.py with a text editor and change values in the settings
definition
		    ''')
	parser.add_argument('--verbose', '-v', action='count',      help='Verbose output')
	parser.add_argument('--targets', '-T', action='store_true', help='Print available targets')
	parser.add_argument('--dry', '-d',     action='store_true', help='Dry run to see commands without executing them')
	parser.add_argument('--lua',           action='store_true', help='Use LuaLaTeX instead of pdflatex')
	parser.add_argument('--ignore-errors', action='store_true', help='Keep running the script when errors are encountered')
	parser.add_argument('--chapter',       metavar='NAME',      help='Chapter to build with the chapter target')
	parser.add_argument('target',          nargs='*',           help='Targets')

	args = parser.parse_args(argv)

	if args.ignore_errors:
		settings.ignore_errors = True
	if args.verbose is not None:
		verbose = args.verbose
	dry = args.dry
	settings.chapter = args.chapter

	if args.targets:
		targets()
		return

	initapplications(use_lualatex=args.lua)

	if len(args.target) == 0:
		if args.chapter is not None:
			print("No targets given, using default target: chapter")
			chapter()
		else:
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