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



USING MAKE AND OTHER UTILITY SCRIPTS

Some convenient Makefile targets:

*) In the main directory [./]:

  make                              # create the full booklet thesis.pdf
  make clean
  make realclean                    # cleanup all mess, including leftover
                                    # mychapter.{dvi,pdf,ps} files.
  make damnthatsreallyclean         # brutally remove all possible temporary
                                    # files

  make cover                        # create the full cover page. By default
                                    # this is cover.pdf.

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

  10pt, 11pt, 12pt                  : text point size
  oneside, twoside
  showgit                           : when showing extra info (with [info] or
                                      [frame] option), also show git related
                                      stuff.
  british                           : Use British spelling in cover (i.e.
                                      fulfilment instead of fulfillment)
  showinstructions                  : show instructions provided by the
                                      faculty. These can be included anywhere
                                      in the tex by commands of the form
                                      \instructionsabstract,
                                      \instructionsintroduction, ...  
  showtodo                          : show todos created by \todo{} or
                                      \todoinline{}
  showtodopriv                      : show todos created by \todopriv{} or
                                      \todoprivinline
  pagebackref                       : show in the bibliography in which page
                                      each paper is cited
  backref                           : TODO

  info                              : put logical page on physical A4 paper and
                                      show some info (compilation time, ...)
  draft                             : show info and compile the document as a
                                      draft
  prelim                            : generate a version of the document
                                      suitable to send to the jury. This means
                                      that the logical page is put on an A4
                                      without info, frame, todos, ... 
  final                             : generate true size (cropped!) pdf without
                                      info, frame, todos, ...
  croppedpdf                        : generate true size pdf
  frame                             : put frame around the logical page and
                                      place the result on an A4 page
  cam                               : instead of a frame, use cropmarks
  cropmarks                         : identical to cam

  cover                             : to be used when generating the coverpage.
                                      Puts the result centered on a landscape A3.

Most of the useful commands provided by this class can be found in the provided
example file 'thesis.tex'. 

Some misc commands that might be useful (try them out):

 \todo{This is a todo}
 \todoinline{This is a todo}
 \todopriv{This is a todo}
 \todoprivinline{\This is a todo}



GENERATING THE COVER PAGE

A full cover page (combining front cover, spine and back cover) can be
generated automatically using the command 'make cover'. This creates a pdf
$(COVERPDF); by default this is 'cover.pdf'.

The width of the spine is set by redefining \adsphdspinewidth (9mm by default).

It can be seen in the provided 'thesis.tex' that all information necessary to
generate a cover page is contained between two markers '%%% COVER: Settings %%%'
and '%%% COVER: End settings %%%'. DO NOT REMOVE THESE!! They are used by the 
Makefile!!

The default front and/or back cover page can be overwritten: 
 - create a file mycoverpage.tex
 - redefine the commands \makefrontcovergeneral and \makebackcovergeneral. For
   an example and more information, see the provided file 'mycoverpage.tex'.

The cover page in the generated pdf has the following structure:

    <--gray bleed--> <--backcoverpage--> <--blue bleed--> <--spine width--> <--blue bleed--> <--frontcoverpage--> <--gray bleed-->

The bleed (both gray and blue) is 7mm by default. I suggest not changing this
value unless you know what you are doing ;)



TROUBLESHOOTING:

 *) To be able to make the chapter compilation work, you should make sure that
    the desired chapter is included in thesis.tex (e.g., using \includechapter{.})!!

 *) If you get spurious empty pages when compiling a single chapter, this is
    probably due to the combination of \cleardoublepage and \includeonly. To
    avoid it, make sure you end all included chapters (and appendices) with
    \cleardoublepage (or use makeemptychapter.sh to generate the chapter
    skeleton).

# vim: expandtab
