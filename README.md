ADS PhD LaTeX template
======================

*This template is the result of a group effort. Please contribute updates and
improvements.*


Information
-----------

This package provides a template when submitting a Phd dissertation
to the [Arenberg Doctoral School](http://set.kuleuven.be/phd/) at
[KU Leuven](http://kuleuven.be).

Latest version of the ADS PhD template is available at 
[github.com/wannesm/adsphd](https://github.com/wannesm/adsphd).

Questions and issues can be submitted to the 
[ADS PhD issues component](https://github.com/wannesm/adsphd/issues) 
at Github.


Directory structure
-------------------

The directory structure looks like this

* `thesis.tex`: Main tex file for the final booklet.
* `defs.tex`: Put your own preamble settings here.
* `run.py`: Simple compilation script.
* `Makefile`
* `Makefile.settings`: This file contains file names and other
                       settings used by make.
* `biblatex.cfg`: Biblatex settings.
* `chapters`
    * `chapter1`: Per chapter a directory with
        * `chapter1.tex`: Tex file with *identical* name
        * `image/`: Images directory. Note that to include
                    a figure in chapter1.tex, you should
                    NOT include the relative path, i.e.,
                    `\includegraphics{myfigure}` and not
                    `{image/myfigure}`!


Using Latex directly
--------------------

The adsphd.cls can be used directly by latex:

    pdflatex thesis
    bibtex thesis
    # biber thesis
    makeindex thesis.glo -s thesis.ist -t thesis.glg -o thesis.gls
    makeindex thesis.nlo -s nomencl.ist -o thesis.nls
    pdflatex thesis
    pdflatex thesis

Any other Latex build tool like latexmk, rubber, SCons, TeXShop or TeXWorks 
should also work out of the box (`makeindex` might not run by default).

Using the simple Python compile script
--------------------------------------

There is a simple and naive Python compilation script supplied which should
work cross-platform.

    python3 run.py             # Compile to pdf
    python3 run.py clean       # Clean auxiliary files
    python3 run.py cleanall    # Clean everything
    python3 run.py newchapter  # Set up files for a new chapter
    python3 run.py --help      # Help and more options

Some settings are available at the top of the `run.py` file.

Using make and other utility scripts
------------------------------------

Some convenient Makefile targets:

**In the main directory [`./`]**:

    make                       # create the full booklet thesis.pdf
    make clean
    make realclean             # cleanup all mess, including leftover
                               # {dvi,pdf,ps} files of main file or the
                               # chapters
    make damnthatsreallyclean  # brutally remove all possible temporary
                               # files


**In a chapter directory [`./chapters/chapterX`]**:

    make                       # Creates chapterX.pdf containing the
                               # TOC, the contents of only chapterX and
                               # the bibliography.
    make bare                  # Create chapterX.pdf containing only the 
                               # chapter text (no TOC, no bibliography).
    make clean                 # remove temporary files left from
                               # compilation
    make realclean             # clean + also remove {ps,pdf} files
    make figurelist            # Print out the names of all figures that are
                                 effectively used in ./chapters/chapterX/chapterX.tex


**Other convenient scripts**:
  
    ./chapters/makeemptychapter.sh # Create the directory structure for a new
                                   # chapter.

Settings for the Makefile script can be found in the `makefile.settings`
file.

Options for the adsphd class
----------------------------

    10pt, 11pt, 12pt      : text point size
    oneside, twoside
    showgit               : when showing extra info (with [info] or
                            [frame] option), also show git version.
                            You need to run latex with '-shell-escape'
                            for this to work! (default in Makefile)

    british               : Use British spelling in cover (i.e.
                            fulfilment instead of fulfillment)

    biblatex              : Use biblatex instead of bibtex.
    biblatexstyle=<name>  : Change the biblatex style.
    biber                 : Use the biber backend for biblatex.
    custombibtex          : Don't load any bib(la)tex files. This way
                            the user can load and customize the
                            bibtex environments he wants. (For
                            advanced use)

    showinstructions      : show instructions provided by the
                            faculty. These can be included anywhere
                            in the tex by commands of the form
                            \instructionsabstract,
                            \instructionsintroduction, ...  

    pagebackref           : show in the bibliography in which page
                            each article is cited.
    backref               : show in the bibliography in which section
                            each article is cited.

    info                  : put logical page on physical A4 paper and
                            show some info (compilation time, ...)
    draft                 : show info and compile the document as a
                            draft
    prelim                : generate a version of the document
                            suitable to send to the jury. This means
                            that the logical page is put on an A4
                            without info, frame, todos, ... 
    final                 : generate true size (cropped!) pdf without
                            info, frame, todos, ...
    print                 : generate true size (cropped!) pdf without
                            info, frame, todos, ... suitable for
                            printing (basically equal to final, but
                            forcing uncolored links, even when this
                            option is given explicitly)
    online                : generate true size (cropped!) pdf without
                            info, frame, todos, ... suitable for
                            printing (basically equal to final, but
                            forcing colored links)
    croppedpdf            : generate true size pdf
    frame                 : put frame around the logical page and
                            place the result on an A4 page
    cam                   : instead of a frame, use cropmarks
    cropmarks             : identical to cam
    subfig                : load package subfig (default)
    subfigure             : load older package subfigure

    covershowcommittee    : show the committee also on the front
                            page.
    coverfontpercent      : change the cover title font size. Should
                            be an integer number between 1 and 100.

Most of the useful commands provided by this class can be found in the provided
example file `thesis.tex`.


Chapters
--------

**Inclusion of normal chapters**

Use the command `\includechapter{.}`, e.g., 

    \includechapter{introduction}

includes `./chapters/introduction/introduction.tex`.

If the chapter is an appendix, use `\includeappendix{.}`!


**Inclusion of 'special' chapters**

The term 'special' chapters refers to the

- preface                 (`preface`)
- dutch abstract          (`prefacenl`)
- abstract                (`abstract`)
- dutch abstract          (`abstractnl`)
- list of publications    (`publications`)
- curriculum vitae        (`cv`)

To include any of the above, use the command

    \includeXXX{filename}

where `XXX` stands for the name indicated in between brackets above, and filename
is as in the \includechapter command. For instance,

    \includeappendix{myappendix} % includes ./chapters/myappendix/myappendix.tex as an appendix

Other special chapters are

  - list of figures
  - list of tables
  - table of contents
  - bibliography

but these different from the above as they are generated using standard
commands (`\listoffigures`, `\listoftables`, `\tableofcontents`,
`\includebibliography`).

For typical usage, see the provided file `thesis.tex`.


Generating the cover page
-------------------------

Most printing services will create their own cover page based
on the details you send them (title, name, affiliation, ...). The template
generates only a front and back cover for the version you want to distribute online,
not for the version you send to the printing service.


Troubleshooting
---------------

* To be able to make the chapter compilation work, you should make sure that
  the desired chapter is included in thesis.tex (e.g., using
  `\includechapter{introduction})`!!
* If you get spurious empty pages when compiling a single chapter, this is
  probably due to the combination of `\cleardoublepage` and `\includeonly`. To
  avoid it, make sure you end all included chapters (and appendices) with
  `\cleardoublepage` (if you use `makeemptychapter.sh` to generate the chapter
  skeleton this is automatically done!)


Todos
-----

We recommend the todonotes package for annotating your text with todo
notes. Note that the adsphd automatically disables todo notes when making
the final version.

    \todo{This is a todo}%
    \todo[inline]{This is a todo}%

**Remark**: to make the above commands interact as little as possible with your
normal text, alway add a % directly after the closing bracket.

If you want to disable todo notes explicitly, you can change the call
`\usepackage{todonotes}` in defs.tex to
`\usepackage[disable]{todonotes}`.


Presentation template
---------------------

A Beamer template has been created by 
[Roland Pastorino](http://www.rolandpastorino.com) and is available on the [KU Leuven 
template page](http://www.kuleuven.be/communicatie/publicaties/powerpointsjablonen).


Contributors
------------

Wannes Meert,
Yves Frederix,
Bart Vandewoestyne,
Nele Famaey,
Tias Guns,
Jan Hendrik Becker,
Steven Op de beeck,
Frederik Colle,
Dominique Devriese,
Marko van Dooren,
Rutger Claes,
Dirk Van Hertem,
Anthony Van Herrewege.


----

vim: expandtab tw=79 ft=markdown
