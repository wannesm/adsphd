The directory structure looks like this

  ./thesis.tex                      # main tex file for the final booklet
  ./defs_thesis.tex                 # thesis wide preamble definitions
  ./Makefile
  ./Makefile.settings               # This file contains file names and other
                                    # settings used by make.

  ./chapters/chapter1               # per chapter a directory with:
  ./chapters/chapter1/chapter.tex   #  + .tex file with identical name
  ./chapters/chapter1/image/        #  + image/ directory
  ./chapters/chapter1/defs.tex      #  + contains notations specific for this
                                         chapter. Only used to create ./defs.tex, 
                                         which should be included in thesis.tex
  
  ./chapters/chapter2
  ./chapters/chapter2/chapter2.tex
  ./chapters/chapter2/image/
  ./chapters/chapter2/defs.tex
  
  ...



The following files will be generated automatically during the compilation process:

  ./defs.tex                        # contains all notations, combined from
                                    # defs_thesis.tex and chapters/*/defs.tex.
  ./chapters/chapterX/Makefile      # Makefile dealing with all dependencies of
                                    # the chapter.



Some convenient Makefile targets:

*) In the main directory [./]:

  make                              # create the full booklet thesis.pdf
  make clean
  make realclean                    # cleanup all mess, including leftover
                                    # mychapter.{dvi,pdf,ps} files.
  make damnthatreallyclean          # brutally remove all possible temporary
                                    # files
*) In a chapter directory [./chapters/chapterX]:

  make                              # Creates chapterX.pdf containing the
                                    # TOC, the contents of only chapterX and
                                    # the bibliography.
  make bare                         # Create chapterX.pdf containing only the 
                                    # chapter text (no TOC, no bibliography).

Other convenient scripts:
  
  ./chapters/makeemptychapter.sh    # Create the directory structure for a new
                                    # chapter.


Options for the adsphd class:

  showinstructions                  : TODO
  showtodo
  backref
  pagebackref
  draft
  prelim
  croppedpdf
  noinfo
  10pt
  11pt
  12pt
  oneside
  twoside
  showgit

TROUBLESHOOTING:

 *) To be able to make the chapter compilation work, you should make sure that
    the desired chapter is included in thesis.tex (e.g., using \includechapter{.})!!

 *) If you get spurious empty pages when compiling a single chapter, this is
    probably due to the combination of \cleardoublepage and \includeonly. To
    avoid it, make sure you end all included chapters (and appendices) with
    \cleardoublepage (or use makeemptychapter.sh to generate the chapter
    skeleton).

# vim: expandtab
