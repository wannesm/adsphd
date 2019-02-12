#!/bin/bash
# Create the skeleton for a chapter

if (( $# != 1 ));
then
	echo "Not enough parameters given. Usage: $@ <chaptername>"
	exit 1
fi


CHAPTERNAME=$1

if [ -d $CHAPTERNAME ];
then
	echo "Chapter with name '$CHAPTERNAME' already exists. Exiting..."
	exit 1
fi

echo "Creating directory $CHAPTERNAME/..."
mkdir -p $CHAPTERNAME

echo "Creating $CHAPTERNAME/$CHAPTERNAME.tex..."
f=$CHAPTERNAME/$CHAPTERNAME.tex
echo "% !TeX root = ../../thesis.tex" > $f
echo "\\chapter{This is $CHAPTERNAME}\\label{ch:$CHAPTERNAME}" > $f
echo "" >> $f
echo "\\ldots" >> $f
echo "" >> $f
echo "" >> $f
echo "" >> $f
echo "" >> $f
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $f
echo "% Keep the following \cleardoublepage at the end of this file, " >> $f
echo "% otherwise \includeonly includes empty pages." >> $f
echo "\\cleardoublepage" >> $f
echo "" >> $f
echo "% vim: tw=70 nocindent expandtab foldmethod=marker foldmarker={{{}{,}{}}}" >> $f

echo "Trying to create chapter Makefile ..."
MAINDIR='..'
if [ -f $MAINDIR/Makefile ];
then
    (cd $MAINDIR; make chaptermakefiles)
	echo " +-> done."
else
    echo " +-> Cannot find main Makefile. You should manually run" +
            "'make chaptermakefiles'."
fi

echo ""
echo "Ok, all done."
