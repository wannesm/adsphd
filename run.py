#!/usr/bin/env python3
# encoding: utf-8
#
# Copyright (C), 2012 by Wannes Meert, KU Leuven
#
# Very simple compile script for the ADSPHD class. For a more extended solution
# use the included Makefile or the latexmk or rubber applications.
#
# No file dependency checks are performed (use TeXnicCenter, Texmaker, latexmk,
# rubber, or make if you want such a feature.
#

import getopt
import glob
import os
import re
import shlex
import sys

from subprocess import *

help_message = '''
Usage:
	./run.py [options] target

Options:
	-h --help      This help
	-v             Verbose output
	-T --targets   Print available targets

Example:
	./run.py compile

Summary:
	Simple compilation script for the ADSPhD class. No file dependency checks
	are performed. Use TeXnicCenter, Texmaker, latexmk, rubber, or make for 
	such a feature.

Settings:
	Open run.py with a text editor and change values in the settings 
	definition.

Remarks:
	This is only a simple script that runs the necessary Latex functions.
'''


## SETTINGS ##

mainfile         = 'thesis.tex'
chaptersdir      = 'chapters'

makebibliography = True
makeindex        = True
makeglossary     = True
makenomenclature = True

verbose          = True

apps = {}

def initapplications():
	"""Initialize the application commands and arguments for the different
	   platforms."""
	global apps
	# Unix and linux are the default setup
	## *NIX ##
	apps['pdflatex']    = App('pdflatex',  '-interaction=nonstopmode -synctex=1 -shell-escape {basename}', verbose)
	apps['bibtex']      = App('bibtex',    '--min-crossref=100 {basename}', verbose)
	apps['glossary']    = App('makeindex', '{basename}.glo -s {basename}.ist -t {basename}.glg -o {basename}.gls', verbose)
	apps['nomenclature']= App('makeindex', '{basename}.nlo -s nomencl.ist -o {basename}.nls', verbose)
	apps['pdfviewer']   = App('acroread',  '{pdffile}', verbose)
	apps['remove']      = App('rm',        '-f {cleanfiles}', verbose)

	if sys.platform == 'darwin':
		## Mac OS X ##
		apps['pdfviewer']   = App('open',      '{pdffile}', verbose)

	elif sys.platform == 'win32' or sys.platform == 'cygwin':
		## Windows ##
		## TODO: does not yet work
		pass


## DERIVED SETTINGS ##

settings = {'basename':'', 'cleanfiles':'', 'pdffile':''}
settings['basename']   = os.path.splitext(mainfile)[0]
settings['cleanfiles'] = " ".join([settings['basename']+"."+ext for ext in ['toc','aux','log','bbl','blg','log','lof','lot','ilg','out','glo','gls','nlo','nls','brf','ist','glg','synctexgz','tgz','idx','ind','-blxbib','fdb_latexmk','synctex.gz']])
settings['pdffile']    = settings['basename']+'.pdf'
#print(settings)


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
def compile():
	sanitycheck()
	latex()


def latex():
	global apps
	rerun = False
	print('#### LATEX ####')
	apps['pdflatex'].run(settings, 'Latex failed')
	if makebibliography:
		rerun = True
		print('#### BIBTEX ####')
		apps['bibtex'].run(settings, 'Bibtex failed')
	if makeindex:
		rerun = True
		print('#### INDEX ####')
	if makeglossary:
		# List of abbreviations
		rerun = True
		print('#### GLOSSARY ####')
		apps['glossary'].run(settings, 'Creating glossary failed')
	if makenomenclature:
		# List of symbols
		rerun = True
		print('#### NOMENCLATURE ####')
		apps['nomenclature'].run(settings, 'Creating glossary failed')
	if rerun:
		print('#### LATEX ####')
		apps['pdflatex'].run(settings, 'Rerunning Latex failed')
		print('#### LATEX ####')
		apps['pdflatex'].run(settings, 'Rerunning Latex failed')


def sanitycheck():
	checknomenclature()
	checkglossary()


def checknomenclature():
	"""Check whether the nomenclature settings are consistent."""
	texfile = open(mainfile, 'r')
	pattern = re.compile(r'^\s*\\usepackage.*{nomencl}.*')
	found = False
	for line in texfile:
		if pattern.search(line) != None:
			found = True
	if not found and makenomenclature:
		print("\nWARNING: Trying to build the nomenclature but you have not include the nomencl Latex package.\n")
	if found and not makenomenclature:
		print("\nWARNING: You have included the nomencl Latex package but in the run.py script this step is not activated.\n")


def checkglossary():
	"""Check whether the glossary settings are consistent."""
	texfile = open(mainfile, 'r')
	pattern = re.compile(r'^\s*\\usepackage.*{glossary.*')
	found = False
	for line in texfile:
		if pattern.search(line) != None:
			found = True
	if not found and makeglossary:
		print("\nWARNING: Trying to build the glossary but you have not include the glossary Latex package.\n")
	if found and not makeglossary:
		print("\nWARNING: You have included the glossary Latex package but in the run.py script this step is not activated.\n")


@target()
def clean():
	"""Remove the auxiliary files created by Latex."""
	global apps
	apps['remove'].run(settings, 'Removing auxiliary files failed')


@target()
def realclean():
	"""Remove all files created by Latex."""
	global apps
	clean()
	newsettings = dict(settings)
	newsettings['cleanfiles'] = 'thesis.pdf thesis.dvi thesis.ps'
	apps['remove'].run(newsettings, 'Removing pdf files failed.')


@target()
def newchapter():
	"""Create the necessary files for a new chapter."""
	chaptername = ""
	validchaptername = re.compile(r'^[a-zA-Z0-9_.]+$')
	while validchaptername.match(chaptername) == None:
		chaptername = input("New chapter file name (only a-z, A-Z, 0-9 or _): ")
	newdirpath = os.path.join(chaptersdir, chaptername)
	print("Creating new directory: "+newdirpath)
	if not os.path.exists(newdirpath):
		os.makedirs(newdirpath)
	newfilepath = os.path.join(newdirpath,chaptername+".tex")
	print("Creating new tex-file: "+newfilepath)
	newfile = open(newfilepath, 'w')
	print("\\chapter{This is "+chaptername+"}\\label{ch:"+chaptername+"}\n", file=newfile)
	print("\n\\ldots\n\n\n\n\
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\
% Keep the following \\cleardoublepage at the end of this file, \n\
% otherwise \\includeonly includes empty pages.\n\
\\cleardoublepage\n", file=newfile)
	newfile.close()

@target()
def view():
	"""Open the generated pdf file in a pdf viewer."""
	print("Opening "+settings['pdffile'])
	pdfviewer.run(settings, 'Opening pdf failed.')

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

## APPLICATION ##

class App:
	def __init__(self, b, o, v=False):
		self.binary = b
		self.options = o
		self.verbose = v

	def run(self, settings, errmsg):
		""" Run the command for the given settings.
			Required settings:
				- basename
				- cleanfiles
		
			:returns: Return code
		"""
		returncode = 1
		try:
			cmd = self.options.format(**settings)
			args = shlex.split(cmd)
			if self.verbose:
				print("Running: "+self.binary+" "+" ".join(args))
			returncode = check_call([self.binary] + args)
		except CalledProcessError as err:
			print(sys.argv[0].split("/")[-1] + ": "+errmsg+" (exitcode "+str(err.returncode)+")", file=sys.stderr)
		return returncode

## COMMAND LINE INTERFACE ##

class Usage(Exception):
	def __init__(self, msg):
		self.msg = msg

def main(argv=None):
	global verbose
	if argv is None:
		argv = sys.argv
	try:
		try:
			opts, args = getopt.getopt(argv[1:], "htT", ["help", "targets"])
		except getopt.error as msg:
			raise Usage(msg)
		
		# option processing
		for option, value in opts:
			if option == "-v":
				verbose = True
			if option in ("-T", "-t", "--targets"):
				targets()
				return
			if option in ("-h", "--help"):
				raise Usage(help_message)
		
		initapplications()
		
		if len(args) == 0:
			print("No targets given, using default target: compile")
			compile()

		for target in args:
			print("Target: "+target)
			if target in knowntargets:
				knowntargets[target]()
			else:
				print("Unknown target")
	
	except Usage as err:
		print(sys.argv[0].split("/")[-1] + ": " + str(err.msg), file=sys.stderr)
		print("\t for help use --help", file=sys.stderr)
		return 2


if __name__ == "__main__":
	sys.exit(main())

