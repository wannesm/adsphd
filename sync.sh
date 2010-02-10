#!/bin/bash
SOURCE=/home/yves/research/thesis

while read i; do 
	echo "Processing $i ..."; 
	rsync $SOURCE/$i $i
done < files2sync.txt
echo " => All done."
