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

For a Beamer presentation template take a look at the [KU Leuven presentation
template](http://www.kuleuven.be/communicatie/publicaties/powerpointsjablonen).


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
   
    cover                 : to be used when generating the coverpage.
                            Puts the result centered on a landscape A3.
                            (Creating a cover is not needed, the printshop
                            will create the cover themselves based on the details
                            you give them.)
   
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

**Important**: most printing services will create their own cover page based
on the details you send them (title, name, affiliation, ...) and do not supply
you with all necessary parameters (e.g., thickness of the paper) because these
differ from machine to machine. Therefore, the generated cover page is only
indicative and probably not used by your printing server (or even correct).


A full cover page (combining front cover, spine and back cover) can be
generated automatically using the command 'make cover'. This creates a pdf
`$(COVERPDF)`; by default this is `cover.pdf`.

The width of the spine is set by redefining `\adsphdspinewidth` (9mm by default).

It can be seen in the provided `thesis.tex` that all information necessary to
generate a cover page is contained between two markers

    %%% COVER: Settings %%%
    ...
    %%% COVER: End settings %%%

DO NOT REMOVE THESE!! They are used by the Makefile!!

The default front and/or back cover page can be overwritten: 

 - create a file `mycoverpage.tex`
 - redefine the commands `\makefrontcovergeneral` and `\makebackcovergeneral`. For
   an example and more information, see the provided file `mycoverpage.tex`.

The cover page in the generated pdf has the following structure:

    <--rbleed--> <--backcoverpage--> <--lbleed--> <--spine width--> <--lbleed--> <--frontcoverpage--> <--rbleed-->

The default bleed (both lbleed and rbleed) is 7mm. I suggest not changing this
value unless you know what you are doing ;) The latter can be done by
redefining `\defaultlbleed` and `\defaultrbleed` respectively.



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
notes. Some commands that might be useful. Note that the adsphd
automatically disables todo notes when making the final version.

    \todo{This is a todo}
    \todo[inline]{This is a todo}

**Remark**: to make the above commands interact as little as possible with your
normal text, alway add a % directly after the closing bracket.

If you want to disable todo notes explicitly, you can change the call
`\usepackage{todonotes}` in defs.tex to
`\usepackage[disable]{todonotes}`.


Presentation template
---------------------

A Beamer template has been created by 
[Roland Pastorino](www.rolandpastorino.com) and is available on the [KU Leuven 
template page](http://www.kuleuven.be/communicatie/publicaties/powerpointsjablonen).


Tips and tricks
---------------

Finetuning the backref package (when _not_ using biblatex). Add the
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
Dirk Van Hertem.


----

vim: expandtab tw=79 ft=markdown
