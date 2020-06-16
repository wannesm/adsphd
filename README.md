ADS PhD LaTeX template
======================

*This template is the result of an ongoing group effort by a number of
volunteers. Help your fellow PhD researcher
in the Issues section and contribute updates if you can. If you are fluent
in TeX and can help monitoring this repository, ask Wannes Meert for admin rights.*

If you want to share tips, tricks, updates, questions or problems: add them
as a [GitHub issue](https://github.com/wannesm/adsphd/issues) or a [GitHub pull request](https://help.github.com/articles/using-pull-requests).


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
* `run.py`: Simple compilation script.
* `Makefile`
* `Makefile.settings`: This file contains file names and other
                       settings used by make.
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

The adsphd.cls class can be used directly by latex:

    pdflatex thesis
    bibtex thesis
    # biber thesis
    makeindex thesis.glo -s thesis.ist -t thesis.glg -o thesis.gls
    makeindex thesis.nlo -s nomencl.ist -o thesis.nls
    pdflatex thesis
    pdflatex thesis

Any other Latex build tool like latexmk, rubber, SCons, TeXShop or TeXWorks 
should also work out of the box (`makeindex` might not run by default in which
case you will not see the glossary).

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

For this to work you need to generate the chapter directory using the
`makeemptychapter.sh` script which also generates a custom Makefile for
the new chapter.

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
    make cover                 # Generate a separate pdf the cover


**Creating a chapter directory**:
  
    ./chapters/makeemptychapter.sh # Create the directory structure for a new
                                   # chapter.

**Settings**:

Settings for the Makefile script can be found in the `makefile.settings`
file.


Options for the adsphd class
----------------------------

    faculty               : faculty
                              [firw] Faculty of Engineering Science
                              [fbiw] Faculty of Bioscience Engineering
                              [fw]   Faculty of Science
                              [fa]   Faculty of Architecture
                              [fiiw] Faculty of Engineering Technology
			      [hiw]  Institute of Philosophy

    department            : department
                              [aow] Department of Earth and Environmental Sciences
                              [arc] Department of Architecture
                              [bio] Department of Biology
                              [bsy] Department of Biosystems
                              [bwk] Department of Civil Engineering
                              [che] Department of Chemistry
                              [cit] Department of Chemical Engineering
                              [cws] Department of Computer Science
                              [elt] Department of Electrical Engineering
                              [mtk] Department of Materials Engineering
                              [mms] Department of Microbial and Molecular Systems
                              [nat] Department of Physics and Astronomy
                              [wtk] Department of Mechanical Engineering
                              [wis] Department of Mathematics
                              [cespp]   Centre for Ethics, Social and Political Philosophy
                              [clps]    Centre for Logic and Philosophy of Science
                              [cmprpc]  Centre for Metaphysics, Philosophy of Religion and Philosophy of Culture
                              [dwmc]    De Wulf-Mansion Centre for Ancient, Medieaval and Renaissance Philosophy
                              [hua]     Husserl-Archives: Centre for Phenomenology and Continental Philosophy

    phddegree             : official PhD degree on diploma (only for the
                            faculties of Engineering Science and Science)

                              faculty=firw
                                [arc] Doctor of Engineering Science (PhD): Architecture
                                [bwk] Doctor of Engineering Science (PhD): Civil Engineering
                                [cit] Doctor of Engineering Science (PhD): Chemical Engineering
                                [cws] Doctor of Engineering Science (PhD): Computer Science
                                [elt] Doctor of Engineering Science (PhD): Electrical Engineering
                                [mtk] Doctor of Engineering Science (PhD): Materials Engineering
                                [wtk] Doctor of Engineering Science (PhD): Mechanical Engineering
                                [gen] Doctor of Engineering Science (PhD)
 
                              faculty=fw
                                [ste] Doctor of Science (PhD): Astronomy and Astrophysics
                                [bct] Doctor of Science (PhD): Biochemistry and Biotechnology
                                [bio] Doctor of Science (PhD): Biology
                                [bfy] Doctor of Science (PhD): Biophysics
                                [che] Doctor of Science (PhD): Chemistry
                                [ggr] Doctor of Science (PhD): Geography
                                [glo] Doctor of Science (PhD): Geology
                                [inf] Doctor of Science (PhD): Informatics
                                [mat] Doctor of Science (PhD): Mathematics
                                [fys] Doctor of Science (PhD): Physics
                                [sta] Doctor of Science (PhD): Statistics
                                [tou] Doctor of Science (PhD): Tourism
                                [gen] Doctor of Science (PhD)

    10pt, 11pt, 12pt      : text point size
    oneside, twoside
    showgit               : when showing extra info (with [info] or
                            [frame] option), also show git version.
                            You need to run latex with '-shell-escape'
                            for this to work! (default in Makefile)

    british               : Use British spelling in cover (i.e.
                            fulfilment instead of fulfillment)

    showinstructions      : show instructions provided by the
                            faculty. These can be included anywhere
                            in the tex by commands of the form
                            \instructionsabstract,
                            \instructionsintroduction, ...  

    info                  : put logical page on physical A4 paper and
                            show some info (compilation time, ...)
    draft                 : show info and compile the document as a
                            draft
    tothejury             : generate a version of the document
                            suitable to send to the jury. This means
                            that the logical page is put on an A4
                            without info, frame, ... 
    final                 : generate true size (cropped!) pdf without
                            info, frame, ...
    print                 : generate true size (cropped!) pdf without
                            info, frame, ... suitable for
                            printing (basically equal to final, but
                            forcing uncolored links, even when this
                            option is given explicitly)
    online                : generate true size (cropped!) pdf without
                            info, frame, ... suitable for
                            printing (basically equal to final, but
                            forcing colored links)
    croppedpdf            : generate true size pdf
    frame                 : put frame around the logical page and
                            place the result on an A4 page
    cam                   : instead of a frame, use cropmarks
    cropmarks             : identical to cam
    epub                  : use a small page size that works better on an
                            epub reader (e.g. Kindle)

    covershowcommittee    : show the committee also on the cover.
    coverfontpercent=<int>: change the cover title font size. Should
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
- dutch preface           (`prefacenl`)
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


Loaded packages
---------------

The following packages are loaded automatically by the adsphd.cls class:

- babel
- calc
- datatool
- etoolbox
- fancyhdr
- fontenc
- framed
- geometry
- hyperref
- ifpdf
- iftex
- ifthen
- kvoptions
- listings
- lmodern
- microtype
- placeins
- rotating
- setspace
- showlabels
- textpos
- xcolor


Generating the cover page
-------------------------

Most printing services will create their own cover page based
on the details you send them (title, name, affiliation, ...). The template
generates only a front and back cover for the version you want to distribute online,
not for the version you send to the printing service.

However, the template has some support to create a separate cover page. Use
`make cover` or `python run.py cover` to generate `cover.tex` and run.


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
Anthony Van Herrewege,
Tassos Natsakis,
Till Nagel,
Job Noormal,
Jesper Cockx,
Laurens Sion,
Felipe Morales,
Pieter Maene,
Roel Van Beeumen.

