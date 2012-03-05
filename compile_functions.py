import sys
import shlex
from subprocess import *
import glob

## APPLICATION ##
class application:
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
		try:
			cmd = self.options.format(**settings)
			args = shlex.split(cmd)
			if self.verbose:
				print("Running: "+self.binary+" with args:")
				print(args)
			returncode = check_call([self.binary] + args)
		except CalledProcessError as err:
			print(sys.argv[0].split("/")[-1] + ": "+errmsg+" (exitcode "+str(err.returncode)+")", file=sys.stderr)
		return returncode

