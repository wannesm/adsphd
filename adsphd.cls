%%
%% Copyright (C) 2010 by Yves Frederix
%% 
%% This file may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either
%% version 1.2 of this license or (at your option) any later
%% version.  The latest version of the license is in:
%% 
%%    http://www.latex-project.org/lppl.txt
%% 
%% and version 1.2 or later is part of all distributions of
%% LaTeX version 1999/12/01 or later.
%% 
%% This file is based on engphd.cls created by Bart Vandewoestyne.
%% 
%%  2010-07-27: Large cleanup and addition of some functionality.
%%             Some of it shamelessly copied from or inspired by
%%             refactoring work by Wannes Meert. 
%%             This includes the [showgit] option, parts of the work
%%             to enable compilation with pdflatex, the redefinition
%%             of \chapter when used in abstract/preface/cv/publications.

\NeedsTeXFormat{LaTeX2e}[2009/09/24]
\ProvidesClass{adsphd}
    [2010/02/02 v0.1 Standard K.U.Leuven Arenberg Doctoral School PhD class]

\newif\ifshowtodo
\newif\ifshowtodopriv
\newif\ifshowinstructions
\newif\ifshellescape
\newif\ifshowgit
\newif\ifbleed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Options that can be passed to adsphd.cls:

% Set papersize.
\newlength{\adsphdpaperheight}
\setlength{\adsphdpaperheight}{240mm}
\newlength{\adsphdpaperwidth}
\setlength{\adsphdpaperwidth}{160mm}
\newlength{\adsphdspinewidth}
%\setlength{\adsphdspinewidth}{20mm} % Ridiculously large ;)
\setlength{\adsphdspinewidth}{9mm}

% Define bleed
\newlength{\bleed}
\setlength{\bleed}{0mm} % No bleed in normal mode
\bleedfalse

% Temporary var
\newlength{\tmplength}

% Show a frame around each logical page by default
\PassOptionsToPackage{frame}{crop}

% Different actions when using pdflatex
\RequirePackage{ifpdf}

% Default options to report class, taken from the ADS template <--
\PassOptionsToClass{fleqn,10pt,twoside}{report}
\ifpdf
	\PassOptionsToPackage{bookmarks,breaklinks,pdfborder={0 0 0}}{hyperref}
\else
	\PassOptionsToPackage{ps2pdf,bookmarks,breaklinks,pdfborder={0 0 0}}{hyperref}
\fi
% --> end ADS 

\DeclareOption{colorlinks}{%
  % Nice colored links in the pdf
  \PassOptionsToPackage{colorlinks=true}{hyperref}
}

% Control backward referencing of in bibliography
\DeclareOption{backref}{%
%  \PassOptionsToClass{backref}{hyperref}
  \PassOptionsToClass{ref}{backref}
}

\DeclareOption{pagebackref}{%
%  \PassOptionsToClass{pagebackref}{hyperref}
  \PassOptionsToClass{pageref}{backref}
}

% Options for crop package
\DeclareOption{noinfo}{%
  \PassOptionsToPackage{off,noinfo}{crop}
}

\DeclareOption{cropmarks}{%
  \PassOptionsToPackage{cam}{crop}
}

% Font size
\DeclareOption{10pt}{%
  \PassOptionsToClass{10pt}{report}
}

\DeclareOption{11pt}{%
  \PassOptionsToClass{11pt}{report}
}

\DeclareOption{12pt}{%
  \PassOptionsToClass{12pt}{report}
}

% Single or double sided?
\DeclareOption{oneside}{%
  \PassOptionsToClass{oneside}{report}
}
\DeclareOption{twoside}{%
  \PassOptionsToClass{twoside}{report}
}

% Misc options
\DeclareOption{showtodo}{%
  \showtodotrue
}

\DeclareOption{showtodopriv}{%
  \showtodoprivtrue
}

\DeclareOption{showinstructions}{%
  \showinstructionstrue
}

% Thank you Wannes:
\DeclareOption{showgit}{%
	\def\gittmpfile{/tmp/gitdescribe.txt} 
	\immediate\write18{touch \gittmpfile} 
	% Check whether shell escapes are enabled 
	\IfFileExists{\gittmpfile}{\shellescapetrue}{\shellescapefalse} 
	\ifshellescape 
		\showgittrue
		%\newcommand*\cropgitinfo{\gitdescribe}
		\immediate\write18{git describe --tags --long --always > \gittmpfile} %
		\openin1=\gittmpfile
		\read1 to \gitdescribe
		\closein2
		\immediate\write18{rm \gittmpfile}%
	\else
		\message{Warning: Shell Escapes are not enabled. Run (pdf)latex with the `-shell-escape' option.}
		\IfFileExists{VERSION}{%
			\showgittrue
			\openin1=VERSION
			\read1 to \gitdescribe
			\closein2
			\message{Warning: Fallback on VERSION file for print git information. (Create such a file with a git-hook)}
		}{%
			\message{Warning: Also no VERSION file found. Git information will not be shown.}
		}
	\fi
}

\DeclareOption{showlabels}{%
  % on by default
}

\DeclareOption{noshowlabels}{%
  \PassOptionsToPackage{final}{showlabels}
}

% Various output options

\DeclareOption{draft}{%
  \PassOptionsToClass{draft}{report}
  \PassOptionsToPackage{frame}{crop}
}

\DeclareOption{croppedpdf}{%
  \typeout{Cropped pdf selected!!!}
  \PassOptionsToPackage{off,noinfo,width=\the\adsphdpaperwidth,%
      height=\the\adsphdpaperheight}{crop}
}

\DeclareOption{cover}{%
  % Only use 7 mm for \bleed{}!!  Do _NOT_ redefine if you don't know
  % what you are doing. For instance Procopia needs 7mm extra on the
  % left to bind the booklet.
  \setlength{\bleed}{7mm}
  \bleedtrue
  % Set crop width to \adsphdpaperwidth+2\bleed
  \newlength{\cropwidth}
  \setlength{\cropwidth}{\adsphdpaperwidth}
  \addtolength{\cropwidth}{2\bleed}
  \PassOptionsToPackage{off,noinfo,width=\the\cropwidth,%
      height=\the\adsphdpaperheight}{crop}
}

\DeclareOption{spine}{%
  %\PassOptionsToPackage{off,frame,noinfo,width=\the\adsphdpaperheight,height=29cm}{crop}
  %\PassOptionsToPackage{off,noinfo,width=245mm,height=29cm}{crop}
  \PassOptionsToPackage{off,noinfo,width=\the\adsphdpaperheight,%
      height=\the\adsphdspinewidth}{crop}
}

\DeclareOption{tothejury}{%
  \typeout{Creating A4 output for the version to send to the jury!!!}
  \PassOptionsToPackage{off,noinfo}{crop}
  \showtodoprivfalse
  \showtodofalse
  \showinstructionsfalse
  \PassOptionsToPackage{final}{showlabels}
}

\DeclareOption{final}{%
  \typeout{Creating true page size pdf!}
  \showtodoprivfalse
  \showtodofalse
  \showinstructionsfalse
  \PassOptionsToPackage{final}{showlabels}
  % Remove all 'extra' stuff and crop page to true size
  \PassOptionsToPackage{off,noinfo,width=\the\adsphdpaperwidth,%
      height=\the\adsphdpaperheight}{crop}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now process the options passed to the packages

\ProcessOptions\relax
\LoadClass{report}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definitions of the input parameters

\def\subtitle#1{\gdef\@subtitle{#1}}
\def\author#1#2{\gdef\@authorf{#1}\gdef\@authorl{#2}}
\def\promotor#1{\gdef\@promotor{#1}}
\def\president#1{\gdef\@president{#1}}
\def\jury#1{\gdef\@jury{#1}}
\def\externaljurymember#1{\gdef\@externaljurymember{#1}}
\def\externalaffiliation#1{\gdef\@externalaffiliation{#1}}
\def\udc#1{\gdef\@udc{#1}}
\def\depot#1{\gdef\@depot{#1}}
\def\isbn#1{\gdef\@isbn{#1}}
\def\rev#1{\gdef\@rev{#1}}
\gdef\@rev{}

\def\faculty#1{\gdef\@faculty{#1}}
\def\department#1{\gdef\@department{#1}}
\def\researchgroup#1{\gdef\@researchgroup{#1}}
\def\address#1{\gdef\@address{#1}}
\def\degree#1{\gdef\@degree{#1}} % It will say "Doctor in \degree"

% Bibtex style
\def\bibstyle#1{\gdef\@bibstyle{#1}}

% Default values
\author{Guust}{Flater}
\promotor{Prof.~Promotor}
\president{Mr.~De~Voorzitter}
\jury{Jurylid 1\\Jurylid 2}
\externaljurymember{External jury member}
\externalaffiliation{External affiliation}
\udc{}
\depot{XXXX/XXXX/XX}
\isbn{XXX-XX-XXXX-XXX-X}

\faculty{Faculty of ....}
\department{Department of ....}
\researchgroup{Research group ...}
\address{Address ...}
\title{Dissertation title ...}
\subtitle{Dissertation subtitle ...}
\degree{... Computer Science ...}
\date{Month Year}

% Bibtex style
\bibstyle{plain}

% Title of chapter with publications
\newcommand{\pubnametoc}{List of publications}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now load a whole bunch of packages:

\RequirePackage{showlabels}

\RequirePackage{subfigure} % Just in case...

% Een aantal packages uit de cls van Bart
%\RequirePackage{xcolor}
\RequirePackage{framed} % voor shaded environment
%
%\RequirePackage{nomencl}
%\renewcommand{\nomname}{List of Symbols}
%
%\RequirePackage{makeidx}

% Taken from ADS <--
\RequirePackage{backref}
\RequirePackage{hyperref}
\RequirePackage[usenames]{color}
% <-- end ADS

% Page layout
%\RequirePackage[dvips=false,pdftex=false,vtex=false]{geometry} # Use this for older versions of geometry (e.g. on Karmic)
\RequirePackage[driver=none]{geometry}
\geometry{
  paperwidth=\adsphdpaperwidth,
  paperheight=\adsphdpaperheight,
  width=120mm,
  height=180mm,
%  width=125mm, %ads
%  height=185mm, %ads
  left=20mm, % Equal margins on both sides: (paperwidth - width) / 2
}

% Load the crop package
\ifpdf
	% Load the crop package
	\RequirePackage[a4,center,pdftex]{crop}
	\RequirePackage[pdftex]{graphicx}
	\DeclareGraphicsExtensions{.pdf, .jpg, .tif, .png}
	% Use utf-8 encoding for foreign characters
	\RequirePackage[utf8]{inputenc}
\else
	% Load the crop package
	\RequirePackage[a4,center,dvips]{crop}
	\RequirePackage[dvips]{graphicx}
	\DeclareGraphicsExtensions{.eps, .ps}
\fi

\RequirePackage[absolute]{textpos}

% Taken from ADS template  <--
\RequirePackage{placeins} % provides \FloatBarrier command

\definecolor{gray}{rgb}{0.600,0.600,0.600}

% TEXTPOS options
\setlength{\TPHorizModule}{1mm}
\setlength{\TPVertModule}{1mm}

% FONTS
\usepackage{microtype}
%\usepackage[T1]{fontenc}
\usepackage{lmodern}  % to make pdf searchable
\usepackage{textcomp} % nice greek alphabet
\usepackage{pifont}   % Dingbats
%\usepackage{booktabs}
\newcommand{\labfont}{\fontfamily{phv}\selectfont} % fonts used in labels
\usepackage{sectsty}
\allsectionsfont{\sffamily}
\DeclareMathAlphabet{\mathpzc}{OT1}{pzc}{m}{it}

% TABLE OF CONTENTS
\usepackage[subfigure,titles]{tocloft}
\renewcommand{\cftchapfont}{\sffamily\bfseries\selectfont}
\renewcommand{\cftchappagefont}{\sffamily\bfseries\selectfont}

% PAGE LAYOUT
%\setlength{\textwidth}{12.5truecm}
%\setlength{\textheight}{18.5truecm} %\pagestyle{plain}
%\setlength{\evensidemargin}{2.46truecm}
%\setlength{\oddsidemargin}{2.46truecm}
\setlength{\jot}{10pt}
\setlength{\parindent}{0mm}
\setlength{\parskip}{7.2pt}
\raggedbottom

\ifshowgit
	%\cropdef[\cropgitinfo]\CROP@@frame\relax\relax\relax{gitinfo}
	%\crop[gitinfo]
	\let\orig@CROP@time=\CROP@time
	\renewcommand{\CROP@time}{\orig@CROP@time\x\gitdescribe}
\fi

% PAGE CONTROL AND QUOTATION
\def\startchapter{
  \ifodd\count0
    \clearpage\thispagestyle{myheadings}\vspace*{\fill}\clearpage
  \else
    \vspace*{\fill}\clearpage\fi}

% HEADERS
\usepackage{fancyhdr}
\pagestyle{fancy}
\renewcommand{\chaptermark}[1]{\uppercase{\markboth{#1}{#1}}}
\renewcommand{\sectionmark}[1]{\uppercase{\markright{#1}}}
\fancyhf{}
\fancyhead[RO]{\scriptsize\sf\rightmark\ \hrulefill\ \thepage}
\fancyhead[RE]{\scriptsize\sf\thepage\ \hrulefill\ \leftmark}
\renewcommand{\headrulewidth}{0pt}
\fancypagestyle{plain}{
\fancyhf{}
\fancyfoot[C]{\scriptsize\sf\thepage}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
}

%% CLEARDOUBLEPAGE
%\makeatletter % <-- commented out as it interferes with \@var variables
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else%
\hbox{}%
\thispagestyle{empty}%
\newpage%
\if@twocolumn\hbox{}\newpage\fi\fi\fi}
%\makeatother % <-- commented out as it interferes with \@var variables

% FIGURES
\renewcommand{\topfraction}{1}  % max fraction of floats at top
\renewcommand{\bottomfraction}{1} % max fraction of floats at bottom
% Parameters for TEXT pages (not float pages):
\setcounter{topnumber}{2}
\setcounter{bottomnumber}{2}
\setcounter{totalnumber}{4}     % 2 may work better
\setcounter{dbltopnumber}{2}    % for 2-column pages
\renewcommand{\dbltopfraction}{0.9} % fit big float above 2-col. text
\renewcommand{\textfraction}{0.07}  % allow minimal text w. figs
% Parameters for FLOAT pages (not text pages):
\renewcommand{\floatpagefraction}{0.7}  % require fuller float pages
% N.B.: floatpagefraction MUST be less than topfraction !!
\renewcommand{\dblfloatpagefraction}{0.7} % require fuller float pages

% CLAP
\def\clap#1{\hbox to 0pt{\hss#1\hss}}
\def\mathllap{\mathpalette\mathllapinternal}
\def\mathrlap{\mathpalette\mathrlapinternal}
\def\mathclap{\mathpalette\mathclapinternal}
\def\mathllapinternal#1#2{\llap{$\mathsurround=0pt#1{#2}$}}
\def\mathrlapinternal#1#2{\rlap{$\mathsurround=0pt#1{#2}$}}
\def\mathclapinternal#1#2{\clap{$\mathsurround=0pt#1{#2}$}}

% CLAP
\def\clap#1{\hbox to 0pt{\hss#1\hss}}
\def\mathllap{\mathpalette\mathllapinternal}
\def\mathrlap{\mathpalette\mathrlapinternal}
\def\mathclap{\mathpalette\mathclapinternal}
\def\mathllapinternal#1#2{\llap{$\mathsurround=0pt#1{#2}$}}
\def\mathrlapinternal#1#2{\rlap{$\mathsurround=0pt#1{#2}$}}
\def\mathclapinternal#1#2{\clap{$\mathsurround=0pt#1{#2}$}}

% CPV
\def\Xint#1{\mathchoice
{\XXint\displaystyle\textstyle{#1}}%
{\XXint\textstyle\scriptstyle{#1}}%
{\XXint\scriptstyle\scriptscriptstyle{#1}}%
{\XXint\scriptscriptstyle\scriptscriptstyle{#1}}%
\!\int}
\def\XXint#1#2#3{{\setbox0=\hbox{$#1{#2#3}{\int}$}
\vcenter{\hbox{$#2#3$}}\kern-.5\wd0}}
\def\ddashint{\Xint=}
\def\dashint{\Xint-}

% VEC
\def\vec#1{{\bf\bm{#1}}}

% DTILDE
\def\dtilde#1{\mathrlap{\rlap{\raise1.2pt\hbox{$\mathsurround=0pt%
\tilde{\phantom{\hbox{$#1$}}}$}}\tilde{\phantom{\hbox{$#1$}}}}#1}

% UBAR
\def\ubar#1{\mathrlap{\rlap{\hbox{$\mbox{\rule{-0.1pt}{0pt}%
                    \mathsurround=0pt\b{\phantom{\hbox{$#1$}}}}$}}}{#1}}

% ORPHANS AND WIDOWS
\clubpenalty=9999
\widowpenalty=9999

% HYPHENATION
\hyphenpenalty=5000
\tolerance=1500

% <-- end ADS

% Setup babel
\usepackage[dutch,english]{babel} % order of passed options seems to be
                                  % important!

% To easily change line spacing
\RequirePackage{setspace}

% Conditionals
\RequirePackage{ifthen}

% Simple arithmetic with lengths
\RequirePackage{calc}

\RequirePackage{rotating}

% Helvetica font for the front cover
\let\origsfdefault\sfdefault
\RequirePackage[scaled]{helvet}
\let\helvetsfdefault\sfdefault
\renewcommand{\sfdefault}{\origsfdefault}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The document consists of 
%  \frontmatter -> Preface, Summary, etc
%  \mainmatter  -> Main text
%  \appendix    -> Appendix
%  \backmatter  -> Bibliography

\newcommand{\frontmatter}{\cleardoublepage\pagenumbering{roman}}

\newcommand{\mainmatter}{\cleardoublepage\pagenumbering{arabic}}

\newcommand{\backmatter}{\cleardoublepage}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Commands for easy chapter inclusion

\def\chaptersdir{chapters}

\newcommand{\includechapter}[1]{%
  \graphicspath{{\chaptersdir/#1/image/}}%
%  \cleardoublepage%
  \include{\chaptersdir/#1/#1}%
}

\newcommand{\includepreface}[1]{%
  \cleardoublepage
  \IfFileExists{\chaptersdir/#1/#1.tex}{
    \let\orig@chapter=\chapter
    \renewcommand{\chapter}{%
      \@ifstar{%
        \orig@chapter*
      }{%
        \message{adsphd.cls Warning: %
Expects chapter* for abstract, changed chapter to chapter*}%
        \orig@chapter*%
      }%
  }
    \include{\chaptersdir/#1/#1}
    \let\chapter=\orig@chapter
  }{
    \chapter*{Preface}
    {\textcolor{red}{Input file \chaptersdir/#1/#1.tex does not exist. Make
    sure its starts with "\textbackslash{}chapter*\{Preface\}"\ldots }}
    \instructionsforeword
  }
}

\newcommand{\includeprefacenl}[1]{%
  \selectlanguage{dutch}
  \cleardoublepage
  \IfFileExists{\chaptersdir/#1/#1.tex}{
    \let\orig@chapter=\chapter
    \renewcommand{\chapter}{%
      \@ifstar{%
        \orig@chapter*
      }{%
        \message{adsphd.cls Warning: %
Expects chapter* for abstract, changed chapter to chapter*}%
        \orig@chapter*%
      }%
  }
    \include{\chaptersdir/#1/#1}
    \let\chapter=\orig@chapter
  }{
    \chapter*{Dankwoord}
    {\textcolor{red}{Input file \chaptersdir/#1/#1.tex does not exist. Make
    sure its starts with "\textbackslash{}chapter*\{Dankwoord\}"\ldots }}
    \instructionsforeword
  }
  \selectlanguage{english}
}

\newcommand{\includeabstract}[1]{%
%  \selectlanguage{english}
  \cleardoublepage
  \IfFileExists{\chaptersdir/#1/#1.tex}{
    \let\orig@chapter=\chapter
    \renewcommand{\chapter}{%
      \@ifstar{%
        \orig@chapter*
      }{%
        \message{adsphd.cls Warning: %
Expects chapter* for abstract, changed chapter to chapter*}%
        \orig@chapter*%
      }%
  }
    \include{\chaptersdir/#1/#1}
    \let\chapter=\orig@chapter
  }{
    \chapter*{Abstract}
    {\textcolor{red}{Input file \chaptersdir/#1/#1.tex does not exist. Make
    sure it starts with "\textbackslash{}chapter*\{Abstract\}"\ldots}}
    \instructionsabstract
  }
}

\newcommand{\includeabstractnl}[1]{%
  \selectlanguage{dutch}
  \cleardoublepage
  \IfFileExists{\chaptersdir/#1/#1.tex}{
    \let\orig@chapter=\chapter
    \renewcommand{\chapter}{%
      \@ifstar{%
        \orig@chapter*
      }{%
        \message{adsphd.cls Warning: %
Expects chapter* for abstract, changed chapter to chapter*}%
        \orig@chapter*%
      }%
  }
    \include{\chaptersdir/#1/#1}
    \let\chapter=\orig@chapter
  }{
    \chapter*{Beknopte samenvatting}
    {\textcolor{red}{Input file \chaptersdir/#1/#1.tex does not exist. Make
    sure it starts with "\textbackslash{}chapter*\{Beknopte
    samenvatting\}"\ldots}}
    \instructionsabstract
  }
  \selectlanguage{english}
}

\newcommand{\includenomenclature}[1]{%
  \IfFileExists{\chaptersdir/#1/#1.tex}{
    \include{\chaptersdir/#1/#1}
  }{
    \chapter*{Nomenclature}
    {\textcolor{red}{Input file \chaptersdir/#1/#1.tex does not exist. Make
    sure it starts with "\textbackslash{}chapter*\{Nomenclature\}"\ldots}}
    \instructionslistofsymbols
  }
}

\newcommand{\includebibliography}[1]{%
  \cleardoublepage
  \phantomsection
  %%\markboth{\uppercase{Bibliography}}{\uppercase{Bibliography}}
  \markboth{{Bibliography}}{{Bibliography}}
  \addcontentsline{toc}{chapter}{Bibliography}
  \bibliographystyle{\@bibstyle}
  \bibliography{#1}
}

\let\tableofcontentsorig\tableofcontents
\renewcommand{\tableofcontents}{%
  \cleardoublepage
  \phantomsection
  \markboth{{Contents}}{{Contents}}
  \addcontentsline{toc}{chapter}{Contents}
  \tableofcontentsorig
}

\let\listoffiguresorig\listoffigures
\renewcommand{\listoffigures}{%
  \cleardoublepage
  \phantomsection
  \markboth{{List of Figures}}{{List of Figures}}
  \addcontentsline{toc}{chapter}{List of Figures}
  \listoffiguresorig
}

\let\listoftablesorig\listoftables
\renewcommand{\listoftables}{%
  \cleardoublepage
  \phantomsection
  \markboth{{List of Tables}}{{List of Tables}}
  \addcontentsline{toc}{chapter}{List of Tables}
  \listoftablesorig
}

\newcommand{\includeappendix}[1]{%
  \cleardoublepage
  \IfFileExists{\chaptersdir/#1/#1.tex}{
    \include{\chaptersdir/#1/#1}
  }{
    \chapter{Appendix}
    {\textcolor{red}{Input file \chaptersdir/#1/#1.tex does not exist.}}
    \instructionsappendices
  }
}

\newcommand{\includecv}[1]{%
  \cleardoublepage
  {
  \def\rightmark{CURRICULUM VITAE}
  \def\leftmark{CURRICULUM VITAE}
  \cleardoublepage
  % assumes that \chapter* is used
  \addcontentsline{toc}{chapter}{Curriculum vitae}
  \IfFileExists{\chaptersdir/#1/#1.tex}{
    \let\orig@chapter=\chapter
    \renewcommand{\chapter}{%
      \@ifstar{%
        \orig@chapter*
      }{%
        \message{adsphd.cls Warning: %
Expects chapter* for CV, changed chapter to chapter*}%
        \orig@chapter*%
      }%
    }
    \include{\chaptersdir/#1/#1}
  \let\chapter=\orig@chapter
  }{
    \chapter*{Curriculum vitae}
    {\textcolor{red}{Input file \chaptersdir/#1/#1.tex does not exist. Make
    sure it starts with "\textbackslash{}chapter*\{Curriculum vitae\}"\ldots}}
    \instructionscv
  }
  }%
}

\newcommand{\includepublications}[1]{%
  {
    % assumes that \chapter* is used
    \addcontentsline{toc}{chapter}{\pubnametoc}
    \IfFileExists{\chaptersdir/#1/#1.tex}{
      \let\orig@chapter=\chapter
      \renewcommand{\chapter}{%
      \@ifstar{%
        \orig@chapter*%
      }{%
        \message{adsphd.cls Warning: %
Expects chapter* for CV, changed chapter to chapter*}%
        \orig@chapter*%
      }%
    }
      \include{\chaptersdir/#1/#1}
      \let\chapter=\orig@chapter
    }{
      \cleardoublepage
      \chapter*{\pubnametoc}
      {\textcolor{red}{Input file \chaptersdir/#1/#1.tex does not exist. Make
      sure it starts with "\textbackslash{}chapter*\{\pubnametoc\}"\ldots}}
      \instructionslistofpublications
    }
  }%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Various utility commands
\newcommand{\todoinline}[1]{%
  \ifshowtodo
    \definecolor{shadecolor}{rgb}{1,1,.65}
    \begin{shaded}{\color{red}\textbf{TODO:} #1}\end{shaded}
  \else
  \fi
}

\setlength{\marginparwidth}{3.5cm}

\newcommand\todomarginpar[1]{\-\marginpar[\raggedright\footnotesize #1]%
{\raggedright\footnotesize #1}}
\newcommand{\todomargin}[1]{%
  \ifshowtodo%
    \definecolor{shadecolor}{rgb}{1,1,.65}%
    \todomarginpar{\begin{shaded}{\color{red}\textbf{TODO:} #1}\end{shaded}}%
  \else
  \fi
}

\let\todo\todomargin

\newcommand{\todoinlinepriv}[1]{%
  \ifshowtodopriv%
    \definecolor{shadecolor}{rgb}{.7,1,.53}%
    \begin{shaded}{\color{red}\textbf{TODO:} #1}\end{shaded}
  \else
  \fi
}
\newcommand{\todomarginpriv}[1]{%
  \ifshowtodopriv%
    \definecolor{shadecolor}{rgb}{.7,1,.53}%
    \todomarginpar{\begin{shaded}{\color{red}\textbf{TODO:} #1}\end{shaded}}%
  \else
  \fi
}
\let\todopriv\todomarginpriv

% 'Roman' references (the reference in 'Proposition 1.1' should be roman, not italics)
\def\@Rref#1{\hbox{\rm \ref{#1}}}
\def\Rref#1{\@Rref{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Redefinitions van Bart:
%\renewcommand\tableofcontents{%
%   \if@twocolumn
%      \@restonecoltrue\onecolumn
%   \else
%      \@restonecolfalse
%   \fi
%   \chapter{\contentsname}
%   \@mkboth{}{}%
%   \@starttoc{toc}%
%   \if@restonecol\twocolumn\fi
%}
%
%\renewcommand\listoffigures{%
%   \if@twocolumn
%      \@restonecoltrue\onecolumn
%   \else
%      \@restonecolfalse
%   \fi
%   \chapter{\listfigurename}%
%   \@mkboth{}{}%
%   \@starttoc{lof}%
%   \if@restonecol\twocolumn\fi
%}
%
%\renewcommand\listoftables{%
%   \if@twocolumn
%      \@restonecoltrue\onecolumn
%   \else
%      \@restonecolfalse
%   \fi
%   \chapter{\listtablename}%
%   \@mkboth{}{}%
%   \@starttoc{lot}%
%   \if@restonecol\twocolumn\fi
%}
%
%\renewenvironment{thebibliography}[1]
%   {\chapter*{\bibname}%
%    \@mkboth{\MakeUppercase\bibname}{\MakeUppercase\bibname}%
%    \addcontentsline{toc}{chapter}{\bibname}%
%    \list{\@biblabel{\@arabic\c@enumiv}}%
%         {\settowidth\labelwidth{\@biblabel{#1}}%
%          \leftmargin\labelwidth
%  \advance\leftmargin\labelsep
%  \@openbib@code
%  \usecounter{enumiv}%
%  \let\p@enumiv\@empty
%  \renewcommand\theenumiv{\@arabic\c@enumiv}}%
%    \sloppy
%    \clubpenalty4000
%    \@clubpenalty \clubpenalty
%    \widowpenalty4000%
%    \sfcode`\.\@m}
%   {\def\@noitemerr
%     {\ClassWarning{Empty `thebibliography' environment}}%
%    \endlist}
%
%\renewenvironment{theindex}
%   {\if@twocolumn
%       \@restonecolfalse
%    \else
%       \@restonecoltrue
%    \fi
%    \columnseprule \z@
%    \columnsep 35\p@
%    \twocolumn[\@makeschapterhead{\indexname}]%
%    \addcontentsline{toc}{chapter}{\indexname}%
%    \@mkboth{\MakeUppercase\indexname}%
%            {\MakeUppercase\indexname}%
%    \thispagestyle{plain}\parindent\z@
%    \parskip\z@ \@plus .3\p@\relax
%    \let\item\@idxitem}
%   {\if@restonecol
%      \onecolumn
%    \else
%      \clearpage
%    \fi}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FTW instructions for each chapter

\newenvironment{ftw_instructions}{
  \definecolor{shadecolor}{gray}{0.95}
  \begin{shaded}
  \textbf{Instructies van de faculteit:}
  }
  {
    \end{shaded}
}

\newcommand{\instructionsforeword}{
  \ifshowinstructions
\begin{ftw_instructions}
In het voorwoord wordt de algemene doelstelling van het werk samengevat in
enkele regels en worden personen, diensten of firma's bedankt voor hun
medewerking bij het tot stand komen van het werk.

De naam van firma's en personen uit deze firma's mogen slechts worden vermeld
mits hun uitdrukkelijke toelating \'en na overleg met de promotor(en)!
Steeds wordt de promotor(en) vermeld, de verantwoordelijke en eventueel de
personen die rechtstreeks geholpen hebben bv.\ door het ter beschikking stelling
van meetresultaten, faciliteiten.  Ook de instantie die eventueel een
doctoraatsbeurs heeft toegekend wordt bedankt (bv.\ FWO, IWT, \ldots).
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsabstract}{
  \ifshowinstructions
\begin{ftw_instructions}
In een beknopte tekst van 10 \`a 15 lijnen worden de belangrijkste
doelstellingen en besluiten geformuleerd, zowel in het Nederlands als in het
Engels.  Zulke samenvattingen kunnen worden gebruikt in wetenschappelijke
verslagen van het departement of de faculteit.  Het Engels moet vlekkeloos zijn.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsnlsummary}{
  \ifshowinstructions
\begin{ftw_instructions}
Voor thesissen van Nederlandstalige studenten die in een vreemde taal opgesteld
zijn, wordt een Nederlandse samenvatting (bv. 5 \`a 10 blz.) van de thesis
voorzien, die een integrerend deel van de doctoraatsthesis uitmaakt.  Deze
Nederlandse samenvatting draagt een Nederlandse titel.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionslistofsymbols}{
  \ifshowinstructions
\begin{ftw_instructions}
Lijst van gebruikte symbolen:
omvat de lijst van de belangrijkste gebruikte symbolen met indices, betekenis
en gebruikte eenheden.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionstableofcontents}{
  \ifshowinstructions
\begin{ftw_instructions}
Inhoudstafel: de inhoudstafel omvat de titels van hoofdstukken en paragrafen
met verwijzing naar de bladzijden.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsintroduction}{
  \ifshowinstructions
\begin{ftw_instructions}
De inleiding situeert de problematiek, beschrijft de stand van de huidige
kennis terzake, omschrijft de voornaamste doelstelligen van het werk, samen
met de beperkende randvoorwaarden en de ter beschikking gestelde middelen en
poneert de belangrijkste stellingen.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionschapters}{
  \ifshowinstructions
\begin{ftw_instructions}
De hoofdstukken: elk hoofdstuk is ingelast met een bepaald doel voor ogen.
Dit doel wordt vermeld in de eerste paragraaf van elk hoofdstuk.
Naargelang de aard van de tekst (experiment, uitvoering, theoretische
ontwikkeling, \ldots) volgen de paragrafen elkaar op.  Beweringen worden altijd
gestaafd, hetzij door eigen experimenten, hetzij door een theoretische
afleiding, hetzij door verwijzingen naar de literatuur.
Elk hoofdstuk eindigt met een kort samenvattend besluit waarbij nagegaan wordt
in hoeverre de doelstelling van het betrokken hoofdstuk verwezenlijkt is.  De
deelbesluiten moeten de lezer automatisch leiden naar het algemeen besluit aan
het einde van het werk.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsconclusions}{
  \ifshowinstructions
\begin{ftw_instructions}
Algemene besluiten:
Verwijzend naar de inleiding en naar de besluiten van de afzonderlijke
hoofdstukken worden op het einde van het proefschrift de voornaamste besluiten
gebundeld.  Hier wordt de nadruk gelegd op de eigen inbreng, de verworven
resultaten, de `stellingen' van het proefschrift en de originele bijdragen tot
het onderzoeksdomein.  De onopgeloste problemen worden aangestipt en
suggesties voor eventueel verder onderzoek worden gemaakt.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsbibliography}{
  \ifshowinstructions
\begin{ftw_instructions}
De bibliografie.
Departementale richtlijnen terzake te volgen.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionslistofpublications}{
  \ifshowinstructions
\begin{ftw_instructions}
Lijst van de publicaties door de doctorandus/a (auteur of co-auteur).
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionscv}{
  \ifshowinstructions
\begin{ftw_instructions}
Beknopt CV van de doctorandus.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsappendices}{
  \ifshowinstructions
\begin{ftw_instructions}
De appendices:
ze omvatten alle gedeelten uit de tekst die weliswaar essentieel zijn voor het
proefschrift, maar waarvan de inlassing in de tekst de leesbaarheid ervan
nadelig zouden be\"invloeden bv. omwille van hun lengte. Zo kunnen bv. de brute
meetresultaten of een computerprogramma met zijn bron, commentaar en
voorbeelden beter thuishoren in een appendix dan in de tekst zelf.
De appendices kunnen desgevallend worden gebundeld in een apart boekdeel.
\end{ftw_instructions}
  \else
  \fi
}

%%%%%%%%%%%%%%%%%%%%%%%% New commands for the Dutch summary  %%%%%%%%%%%%%%%%%%%

%\newcommand\nlsamenvattingname{Nederlandse samenvatting}
%
%\newcommand\nlsamenvatting[1]{%
%   \chapter[\nlsamenvattingname]{{\LARGE \nlsamenvattingname} \\ #1}
%}
%
%\newcounter{nlsection}
%\newcounter{nlsubsection}[nlsection]
%\renewcommand\thenlsection{\@arabic\c@nlsection}
%\renewcommand\thenlsubsection{\thenlsection.\@arabic\c@nlsubsection}
%
%\newcommand*\l@nlsection{\l@chapter}
%\newcommand*\l@nlsubsection{\l@section}
%
%\newcommand\nlsection[1]{%
%   \refstepcounter{nlsection}
%   \section*{\@seccntformat{nlsection}#1}%
%   \addcontentsline{nltoc}{nlsection}{\protect\numberline{\thenlsection}#1}
%}
%
%\newcommand\nlsubsection[1]{%
%   \refstepcounter{nlsubsection}
%   \subsection*{\@seccntformat{nlsubsection}#1}%
%   \addcontentsline{nltoc}{nlsubsection}%
%      {\protect\numberline{\thenlsubsection}#1}
%}
%
%\newcommand\nlsubsubsection[1]{%
%   \subsubsection*{#1}
%}
%
%\newcommand\nltableofcontents{%
%   \renewcommand\@pnumwidth{2.85em}
%   \if@twocolumn
%      \@restonecoltrue\onecolumn
%   \else
%      \@restonecolfalse
%   \fi
%   \section*{\contentsname}%
%   \@starttoc{nltoc}%
%   \if@restonecol\twocolumn\fi
%   \renewcommand\@pnumwidth{1.55em}
%}
%
%\newfont{\kul}{kullogo}

%\newcommand{\clearemptydoublepage}{\newpage{\pagestyle{empty}\cleardoublepage}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define front and back cover + redefine the title page

% Taken from ADS <--

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Provide front cover
\newcommand{\makefrontcover}{\makefrontcovergeneral{0mm}{1}}
% \makefrontcovergeneral{xskip}{}clearpage
\newcommand{\makefrontcovergeneral}[2]{%
% Use Helvetica
\renewcommand{\sfdefault}{\helvetsfdefault}
\thispagestyle{empty}
% Now using \usepackage[absolute]{textpos}. The positioning become a lot
% robuster this way wrt changes in margins etc.
%
% Put sedes at top center
\begin{textblock*}{160mm}(0mm+#1,0mm)
\vspace{-\parskip}
\begin{center}
\includegraphics[width=8mm]{image/sedes}
\end{center}
\end{textblock*}
%
% Create gray box
\begin{textblock*}{100mm+\bleed}(60mm+#1,20mm)
\textblockcolour{gray}
\vspace{-\parskip}
%\parbox[c][20mm]{(97.92mm+\bleed)}{ % This does not work. The bleed is
                                     % hardcoded in the texblock size. Fixme!
\hspace*{2mm}
\parbox[c][20mm]{97.92mm}{
{\bf \small \textcolor{white} {\sffamily Arenberg Doctoral School of Science, Engineering \& Technology}}\\
{\sffamily\small \textcolor{white} {\@faculty}}\\
{\sffamily\small \textcolor{white} {\@department}}
}
\end{textblock*}
%
% Create blue background 
\begin{textblock*}{60mm+\bleed}(0mm-\bleed+#1, 20mm)
\textblockcolour{}
\includegraphics[width=60mm+\bleed,height=20mm]{image/blue}
\end{textblock*}
%
% Put KULeuven logo on top of the blue background
\begin{textblock*}{60mm}(0mm+#1, 20mm)
\textblockcolour{}
%\vspace{-\parskip}
\includegraphics*[height=20mm]{image/kullogo2}
\end{textblock*}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Title, subtitle, authorname, text and date can be moved around.
% Change the textblock* commands below. 
%
% Syntax of textblock environment:
% 
%   \begin{textblock*}{width}(xpos,ypos)
%     ...
%   \end{textblock*}
% 
% !! Make sure not to remove the '+#1' part!!!
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Place the title
\begin{textblock*}{120mm}(17.5mm+#1,112.5mm)
\textblockcolour{}
\vspace{-\parskip}
\raggedright\selectfont\LARGE\sffamily\textbf{\@title}
\end{textblock*}
%
% Place the subtitle
\begin{textblock*}{120mm}(17.5mm+#1,125mm)
\textblockcolour{}
\vspace{-\parskip}
\Large\sffamily{\@subtitle}
\end{textblock*}
%
% Place the author name
\begin{textblock*}{120mm}(17.5mm+#1,147.5mm)
\textblockcolour{}
\vspace{-\parskip}
\Large\sffamily\@authorf\ \MakeUppercase\@authorl
\end{textblock*}
%
% Place the misc text
\begin{textblock*}{60mm}(97.5mm+#1,192.5mm)
\textblockcolour{}
\vspace{-\parskip}
{\small\sffamily Dissertation presented in partial\\
fulfillment of the requirements for\\
the degree of Doctor\\
in \@degree}
\end{textblock*}
%
% Place date
\begin{textblock*}{160mm}(0mm+#1,221.5mm)
\textblockcolour{}
\vspace{-\parskip}
\begin{center} {\small\sffamily\@date }\end{center}
\end{textblock*}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Only add empty pages if asked for
\ifthenelse{\equal{#2}{1}}
{
  \newpage
  \thispagestyle{empty} \mbox{}
  \renewcommand{\sfdefault}{\origsfdefault}
  \newpage
}{}

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redefine title page
\renewcommand{\maketitle}{%
\cleardoublepage
\thispagestyle{empty} \mbox{}

%\begin{textblock}{120}(0,37.5)
\begin{textblock}{120}(17.5,70)
\textblockcolour{}
\vspace{-\parskip}
\Large\sffamily\textbf{\@title}
\end{textblock}
%
%\begin{textblock}{120}(0,47.5)
\begin{textblock}{120}(17.5,82.5)
\textblockcolour{}
\vspace{-\parskip}
\large\sffamily{\@subtitle}
\end{textblock}
%
%\begin{textblock}{120}(0,72.5)
\begin{textblock}{120}(17.5,105)
\textblockcolour{}
\vspace{-\parskip}
\large\sffamily\textbf{\@authorf\ \MakeUppercase\@authorl}
\end{textblock}
%
%\begin{textblock}{120}(0,125)
\begin{textblock}{160}(17.5,157.5)
\textblockcolour{}
\vspace{-\parskip}
\begin{minipage}[t]{7.32cm}
%  \begin{tabular}[t]{p{6.9cm}}
    Jury:\\
    \@president, chair\\
    \@promotor, promotor\\
    \@jury \\
    \@externaljurymember \\
    \rule{0.25cm}{0pt}(\@externalaffiliation)\\
    \\
    \if\empty\@udc \else U.D.C. \@udc\fi
%  \end{tabular}
\end{minipage}
\begin{minipage}[t]{7cm}
%  \begin{tabular}[t]{l}
    Dissertation presented in partial\\
    fulfillment of the requirements for\\
    the degree of Doctor \\
    in \@degree
%  \end{tabular}
\end{minipage}

%\begin{tabular}{p{7cm}l}
% Jury:                                                   & Dissertation presented in partial\\
% \@president, president                                  & fulfillment of the requirements for\\
% \@promotor, promotor                                    & the degree of Doctor \\
% titles first name last name                             & in \@degree\\
% titles first name last name                             & \\
%   \rule{0.25cm}{0pt}(external affiliation)              & \\
%                                                         & \\
% U.D.C. \@udc
%\end{tabular}
\end{textblock}
%\vfill
%\begin{center} {\@date} \end{center}
\begin{textblock}{160}(0,202.5)
\textblockcolour{}
\vspace{-\parskip}
\begin{center} \@date \end{center}
\end{textblock}
% NEW PAGE
\pagenumbering{roman}
\newpage
\thispagestyle{empty}
\mbox{}
\vfill
{\setlength{\parindent}{0ex}\copyright{}~Katholieke Universiteit Leuven -- \@faculty \\
\@address, B-3001 Heverlee (Belgium)}

\bigskip
\selectlanguage{dutch}
Alle rechten voorbehouden. Niets uit deze uitgave mag worden vermenigvuldigd en/of openbaar gemaakt
worden door middel van druk, fotocopie, microfilm, elektronisch
of op welke andere wijze ook zonder voorafgaande schriftelijke
toestemming van de uitgever.

\medskip
\selectlanguage{english}
All rights reserved. No part of the publication may be reproduced
in any form by print, photoprint, microfilm or any other means
without written permission from the publisher.

\medskip

D/\@depot\\
ISBN \@isbn

\vspace{2cm}

\cleardoublepage
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Provide back cover
\newcommand{\makebackcover}{\makebackcovergeneral{0mm}{1}}
% \makebackcovergeneral{xskip}{clearpage}
\newcommand{\makebackcovergeneral}[2]{%
% Use Helvetica
\renewcommand{\sfdefault}{\helvetsfdefault}
%
% Only add empty pages if asked for
\ifthenelse{\equal{#2}{1}}
{
  \cleardoublepage \mbox{}
  \thispagestyle{empty}
  \newpage
}{}
\thispagestyle{empty}
%
% Create gray box
\begin{textblock*}{152.5mm+\bleed}(-\bleed+#1,20mm)
\textblockcolour{gray}
\vspace{-\parskip}
%\hspace*{-\bleed}\parbox[c][20mm]{(151.2mm+\bleed)}{ % This does not work. The bleed is
                                     % hardcoded in the texblock size. Fixme!
\parbox[c][20mm]{151.2mm+\bleed}{
\flushright
\vspace{-3mm}
{\bf \scriptsize \textcolor{white} {\sffamily{}Arenberg Doctoral School of Science, Engineering \& Technology} \ \ }\\[-1mm]
{\scriptsize \textcolor{white} {\sffamily\@faculty\ \ }}\\[-1.2mm]
{\scriptsize \textcolor{white} {\sffamily\@department \ \ }}\\[-1.2mm]
{\scriptsize \textcolor{white} {\sffamily\@researchgroup\ \ }}\\[-1.2mm]
{\scriptsize \textcolor{white} {\sffamily\@address\ \ }}\\[-1.2mm]
{\scriptsize \textcolor{white} {\sffamily{}B-3001 Heverlee\ \ }}
}
\end{textblock*}
%
%
% Create blue background
\setlength{\tmplength}{\adsphdpaperwidth}
\addtolength{\tmplength}{-152mm}
\addtolength{\tmplength}{\bleed}
\begin{textblock*}{\tmplength}(152.0mm+#1,20mm)
\textblockcolour{}
\includegraphics[width=\tmplength,height=20mm]{image/blue}%
\end{textblock*}
%
% Put KULeuven logo on top
\begin{textblock*}{7mm}(153.37mm+#1,20mm)
\textblockcolour{}
\vspace{-\parskip}
\includegraphics*[angle=90,height=20mm]{image/kullogo2}%
\end{textblock*}
%
% Put logo of the association at the bottom right
\begin{textblock*}{12mm}[0.5,0.5](142.5mm+#1,223.5mm)
\textblockcolour{}
\vspace{-\parskip}
\includegraphics*[width=12mm]{image/ASSO_ZEGEL_ZW}
\end{textblock*}
%
% Restore font
\renewcommand{\sfdefault}{\origsfdefault}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the spine of the booklet
\newcommand{\defaultspinetitlewidth}{90mm}
\newcommand{\spinetitlewidth}{\defaultspinetitlewidth}

%\newcommand{\makespine}[2]{\makespinegeneral{xskip}{clearpage}{spinewidth}{spinetitlewidth}}
\newcommand{\makespine}[2]{\makespinegeneral{0mm}{1}{#1}{#2}}
\newcommand{\makespinegeneral}[4]{%
  % Use Helvetica
  \renewcommand{\sfdefault}{\helvetsfdefault}
  %
  % Get adsphdspinewidth as #3
  \renewcommand{\adsphdspinewidth}{#3}
  % 
  % Get spinetitlewidth as #4
  \ifthenelse{\equal{#4}{}}
  {}{
    \renewcommand{\spinetitlewidth}{#4}
  }
  %
  % Only clear page if asked for
  \ifthenelse{\equal{#2}{1}}
  {
    \cleardoublepage \mbox{}%
    \thispagestyle{empty}%
  }{}
  %
  % Create blue box
  \begin{textblock*}{\adsphdspinewidth}(0mm,20mm)
  \textblockcolour{}
  \vspace{-\parskip}
  \includegraphics[width=\adsphdspinewidth,height=20mm]{image/blue}%
  \end{textblock*}
  %
  \newlength{\authorlen}
  \settowidth{\authorlen}{\large\sffamily\@authorf\ \MakeUppercase\@authorl}
  %
  \begin{textblock*}{\adsphdspinewidth}(0mm, 53mm)
  \textblockcolour{}
  % Rotate the text
  \begin{turn}{-90}
  \makebox[\adsphdpaperheight-60mm][c]{% 20mm(white)+20mm(blue)+13mm(space before name)+7mm(after date)
  %
  % Place author
  \parbox[c][\adsphdspinewidth]{(\authorlen)}{
  \large\sffamily\@authorf\ \MakeUppercase\@authorl%
  }
  \hfill
  %
  % Place title
  \parbox[c][\adsphdspinewidth]{\spinetitlewidth}{
    \centering
    \setstretch{.85}
    \normalsize\sffamily\textbf{\MakeUppercase\@title}
  }
  %
  % Place date
  \hfill\large\sffamily\@date
  }
  \end{turn}
  \end{textblock*}
%%  \vfill
%  \renewcommand{\sfdefault}{\origsfdefault}
%}


%\newcommand{\makespinehorizontal}{%
%  \renewcommand{\sfdefault}{\helvetsfdefault}
%  \cleardoublepage \mbox{}%
%  \thispagestyle{empty}%
%
%  \begin{textblock}{20}(19.994,0)
%  \textblockcolour{}
%  \vspace{-\parskip}
%  \includegraphics[width=20mm,height=\adsphdspinewidth]{image/blue}%
%  \end{textblock}
%
%  \newlength{\authorlen}
%  \settowidth{\authorlen}{\large\sffamily\@authorf\ \MakeUppercase\@authorl}
%  \begin{textblock}{180}(53,0)
%  \parbox[c][\adsphdspinewidth]{(\authorlen)}{
%  \large\sffamily\@authorf\ \MakeUppercase\@authorl%
%  }
%%  \vspace{-\parskip}
%  \textblockcolour{}
%  \hfill
%  \parbox[c][\adsphdspinewidth]{\spinetitlewidth}{
%    \centering
%    \setstretch{.85}
%    \normalsize\sffamily\textbf{\MakeUppercase\@title}
%  }
%  \hfill\large\sffamily\@date
%  \end{textblock}
%%  \vfill
%  \renewcommand{\sfdefault}{\origsfdefault}
}

\endinput
%%
%% End of file `adsphd.cls'.
%% vim: tw=70 expandtab
