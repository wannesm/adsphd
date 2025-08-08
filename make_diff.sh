# created by Ignace Bossuyt, July-August 2025 

# FUNCTION 	make_diff
# 	INPUT: 	git-hash of a previous version w.r.t which 
#			a diff-version is desired, henceforth called $HASH
#	OUPUT: thesis_diff_$HASH.pdf, 
#			a pdf-file that contains the desired diff-version

# The code makes use of the following packages:
#	latexdiff: https://ctan.org/pkg/latexdiff
#	perl: https://www.perl.org/
#	and, of course, we use some bash commands

# DISCUSSION:
# 	* Currently, there is one central limitation, namely, 
#	that the old version and the new version
#	need to have the same 'chapter structure' -- that is,
#	their chapter folders have to have equal names.
#	(Well, actually, if there is a new chapter in the newest version, 
#	it will be included in thesis_diff_$HASH.tex, 
#	but it will not be marked as a change.)

#	* Why is this software 'useful'?
#	Due to the multifile nature of the adsphd project, 
#	creating diff-versions using 'standard' tools, such as latexdiff,
#	as such, is slightly nontrivial. 


# A] first define a function
make_diff () {
#	 1.
# 	get the old chapter files from the git worktree
	git worktree add -f oldfiles $1
	rm -r oldchapters
	mv oldfiles/chapters oldchapters
	rm -r oldfiles

#	 2.
#	 create diff-files and put them in a directoryµ

#	 	2.1
#		create some folders
	rm -r diffchapters
	cp -r chapters diffchapters

	rsync -a -u chapters/ diffchapters/

#	 	2.2
#	 	compute the diff files
	cat /dev/null > null
	for file in chapters/*/*.tex ; do 
		yow=$(basename "$file")
		yow=${yow%.*}
		latexdiff -pnull oldchapters/$yow/$yow.tex chapters/$yow/$yow.tex > diffchapters/$yow/$yow.tex 
		echo oldchapters/$yow/$yow.tex ; 
	done

	cp adsphd.cls adsphd_diff.cls
	sed -i -e 's/{chapters}/{diffchapters}/g' adsphd_diff.cls

#	3. 
#	modify the document thesis.tex into thesis_diff.tex
	cp -f thesis.tex thesis_diff.tex
	perl -i -p0e 's/this line will be replaced to create a diff\n/`cat diff_text`/se' thesis_diff.tex  ...
	sed -i -e 's/{adsphd}/{adsphd_diff}/g' thesis_diff.tex

# 	4. 
# 	compile the main diff document
#	TODO: this can be improved, more in line with the existing makefile
#	also, bibtex may need to be replaced with biber	
	pdflatex -interaction nonstopmode thesis_diff
	bibtex thesis_diff
	pdflatex -interaction nonstopmode thesis_diff
	bibtex thesis_diff
	bibtex thesis_diff
	pdflatex -interaction nonstopmode thesis_diff

#	5. 
#	remove redundant files
	cp thesis_diff.pdf thesis_diff_$1.pdf
	rm thesis_diff.pdf

	rm adsphd_diff.cls
	rm null
	rm -r oldchapters
	rm -r diffchapters
	rm thesis_diff.*
}

# B] use the function:
# 	as an argument, give the git hash of the previous version 
#	of your thesis -- for example
make_diff d7e19ee
