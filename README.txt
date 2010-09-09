The directory structure looks like this

  ./thesis.tex                      # main tex file for the final booklet
  ./defs_thesis.tex                 # thesis wide preamble definitions
  ./Makefile
  ./Makefile.settings               # This file contains file names and other
                                    # settings used by make.

  ./chapters/chapter1               # per chapter a directory with:
  ./chapters/chapter1/chapter1.tex  #  + .tex file with identical name
  ./chapters/chapter1/image/        #  + image/ directory. Note that to include
                                         a figure in chapter1.tex, you should
                                         NOT include the relative path, i.e.,
                                            \includegraphics{myfigure} % and not {image/myfigure}!
  ./chapters/chapter1/defs.tex      #  + contains notations specific for this
                                         chapter. Only used to create ./defs.tex, 
                                         which should be included in thesis.tex
  
  ./chapters/chapter2
  ./chapters/chapter2/chapter2.tex
  ./chapters/chapter2/image/
  ./chapters/chapter2/defs.tex
  
  ...



The following files will be generated automatically during the compilation
process:

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
                                    # {dvi,pdf,ps} files of main file or the
                                    # chapters
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
  make clean                        # remove pdf's
  make figurelist                   # Print out the names of all figures that are
                                      effectively used in ./chapters/chapterX/chapterX.tex


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
                                      \todoinline{}.
  showtodopriv                      : show todos created by \todopriv{} or
                                      \todoprivinline.

  pagebackref                       : show in the bibliography in which page
                                      each article is cited.
  backref                           : show in the bibliography in which section
                                      each article is cited.

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


Some misc commands that might be useful (try them out, but do not forget to add
the [showtodo,showtodopriv] options or you won't see anything):

 \todo{This is a todo}
 \todoinline{This is a todo}
 \todopriv{This is a todo}
 \todoprivinline{\This is a todo}

REMARK: to make the above commands interact as little as possible with your
normal text, alway add a % directly after the closing bracket.


INCLUSION OF NORMAL CHAPTERS

Use the command \includechapter{.}, e.g., 
    \includechapter{introduction} % includes ./chapters/introduction/introduction.tex

If the chapter is an appendix, use \includeappendix{.}!


INCLUSION OF 'SPECIAL' CHAPTERS

The term 'special' chapters refers to the

  - preface                 (preface)
  - dutch abstract          (prefacenl)
  - abstract                (abstract)
  - dutch abstract          (abstractnl)
  - list of publications    (publications)
  - curriculum vitae        (cv)

To include any of the above, use the command

    \includeXXX{filename}

where XXX stands for the name indicated in between brackets above, and filename
is as in the \includechapter command. For instance,

    \includeappendix{myappendix} % includes ./chapters/myappendix/myappendix.tex as an appendix


Other special chapters are

  - list of figures
  - list of tables
  - table of contents
  - bibliography            

but these different from the above as they are generated using standard
commands (\listoffigures, \listoftables, \tableofcontents,
\includebibliography).

For typical usage, see the provided file thesis.tex.


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

    <--rbleed--> <--backcoverpage--> <--lbleed--> <--spine width--> <--lbleed--> <--frontcoverpage--> <--rbleed-->

The default bleed (both lbleed and rbleed) is 7mm. I suggest not changing this
value unless you know what you are doing ;) The latter can be done by
redefining \defaultlbleed and \defaultrbleed respectively.



TROUBLESHOOTING:

 *) To be able to make the chapter compilation work, you should make sure that
    the desired chapter is included in thesis.tex (e.g., using
    \includechapter{introduction})!!

 *) If you get spurious empty pages when compiling a single chapter, this is
    probably due to the combination of \cleardoublepage and \includeonly. To
    avoid it, make sure you end all included chapters (and appendices) with
    \cleardoublepage (if you use makeemptychapter.sh to generate the chapter
    skeleton this is automatically done!)


TIPS AND TRICKS

*) Finetuning the backref package (when _not_ using biblatex). Add the
   following to your preamble:

  % See [http://n2.nabble.com/backref-td478438.html]:
  % simple backref command redefinition to avoid double entries
  \makeatletter
  \ifadsphd@biblatex\else
    \ifadsphd@pagebackref%
      \renewcommand*{\backref}[1]{}
      % redefinition of the actually used \backrefalt 
      \renewcommand*{\backrefalt}[4]{% 
      \ifcase #1 % 
         % case: not cited 
      \or 
         % case: cited on exactly one page 
         Cited on page~#2.
      \else 
         % case: cited on multiple pages 
         Cited on pages~#2.
      \fi}
    \else
      \renewcommand*{\backref}[1]{}
      % redefinition of the actually used \backrefalt 
      \renewcommand*{\backrefalt}[4]{% 
      \ifcase #1 % 
         % case: not cited 
      \or 
         % case: cited on exactly one page 
         Cited in Section~#2.
      \else 
         % case: cited on multiple pages 
         Cited in Sections~#2.
      \fi}
    \fi
  \fi
  \makeatother


# vim: expandtab tw=79
