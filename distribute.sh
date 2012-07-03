#!/bin/bash

git describe --tags --long > VERSION
git show -s --format="%H %ci" >> VERSION

echo VERSION Makefile Makefile.settings run.py README.txt *.cls *.bib chapters *.tex *.py *.sty image >MANIFEST2;
cat MANIFEST2
cat MANIFEST2 | tr ' ' '\n' | sed -e "s/^/adsphd.src\//g" > MANIFEST; 

ADSPHDDIR=$(pwd)
cd ..

if [ ! -h adsphd.src ]; then
	ln -s $ADSPHDDIR adsphd.src
fi;

echo "TARRING"
tar -czvf $ADSPHDDIR/adsphd.src.tgz $(cat $ADSPHDDIR/MANIFEST);
rm $ADSPHDDIR/MANIFEST;
rm adsphd.src;


