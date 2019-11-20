%%
%% Copyright (C) 2009-2016 by KU Leuven
%%               Wannes Meert, Yves Frederix, Bart Vandewoestyne, ...
%%
%% This file may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either
%% version 1.2 of this license or (at your option) any later
%% version.  The latest version of the license is in:
%% 
%%    http://www.latex-project.org/lppl.txt
%% 
%% Information about the ADS guidelines:
%%
%%    https://set.kuleuven.be/intranet-associatie/ADS/guidelines_PhDthesis.htm
%% 
\NeedsTeXFormat{LaTeX2e}[2009/09/24]
\ProvidesClass{adsphd}
    [2016/05/30 v1.3 Standard KU Leuven Arenberg Doctoral School PhD class]

\newif\ifshellescape

% Different actions when using pdflatex
\RequirePackage{ifpdf}
\RequirePackage{iftex}

%\RequirePackage[usenames]{color}
\RequirePackage[usenames,dvipsnames,svgnames,table]{xcolor}

% Fix papersize
\newlength{\adsphdpaperheight}
\setlength{\adsphdpaperheight}{240mm}
\newlength{\adsphdpaperwidth}
\setlength{\adsphdpaperwidth}{160mm}

% Set default spine width
\newlength{\adsphdspinewidth}
\setlength{\adsphdspinewidth}{9mm}

% Define bleed
\newlength{\defaultlbleed}
\setlength{\defaultlbleed}{3mm}
\newlength{\defaultrbleed}
\setlength{\defaultrbleed}{3mm}
\newlength{\defaulttbleed}
\setlength{\defaulttbleed}{3mm}
\newlength{\defaultbbleed}
\setlength{\defaultbbleed}{3mm}
\newlength{\lbleed}
\setlength{\lbleed}{0mm} % No bleed in normal mode
\newlength{\rbleed}
\setlength{\rbleed}{0mm} % No bleed in normal mode
\newlength{\tbleed}
\setlength{\tbleed}{0mm} % No bleed in normal mode
\newlength{\bbleed}
\setlength{\bbleed}{0mm} % No bleed in normal mode

% Temporary var
\newlength{\tmplength}

% Colors
\definecolor{blueXIIdark}{cmyk}{.81,.19,.12,.06}
\definecolor{blueXIIlight}{cmyk}{.59,.05,.02,.00}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Options that can be passed to adsphd.cls:

% Use kvoptions to process key=value type options
% Based on http://www.texdev.net/wp-content/uploads/2009/03/keyval.pdf
\RequirePackage{kvoptions}
\SetupKeyvalOptions{
    family=adsphd,
    prefix=adsphd@}

% attributes
\DeclareBoolOption{info}
\DeclareBoolOption{frame}
\DeclareBoolOption{cropmarks}
\DeclareBoolOption{cam}
\DeclareBoolOption{showinstructions}
\DeclareBoolOption{showgit}
\DeclareBoolOption{showlabels}
\DeclareBoolOption{cover}
\DeclareBoolOption{british}
\DeclareBoolOption{bleed}
\DeclareBoolOption{nohyperref}
\DeclareBoolOption{epub}

% font and style
\DeclareVoidOption{10pt}{
  \PassOptionsToClass{10pt}{report}
}
\DeclareVoidOption{11pt}{
  \PassOptionsToClass{11pt}{report}
}
\DeclareVoidOption{12pt}{
  \PassOptionsToClass{12pt}{report}
}
\DeclareVoidOption{oneside}{
  \PassOptionsToClass{oneside}{report}
}
\DeclareVoidOption{twoside}{
  \PassOptionsToClass{twoside}{report}
}
\DeclareBoolOption{draft}
\DeclareBoolOption{croppedpdf}
\DeclareBoolOption{tothejury}{}
\DeclareBoolOption{final}{}
\DeclareBoolOption{print}{}
\DeclareBoolOption{online}{}

% links
\DeclareBoolOption{colorlinks}

% Cover options
\DeclareStringOption{coverfontpercent}
\DeclareBoolOption{covershowcommittee}
\DeclareComplementaryOption{coverhidecommittee}{covershowcommittee}

% Faculty
\DeclareStringOption{doctoralschool}
\DeclareStringOption{faculty}
\DeclareStringOption{department}
\DeclareStringOption{phddegree}

% Default values
\setkeys{adsphd}{info=true,coverfontpercent=100}
\PassOptionsToClass{fleqn,10pt,twoside}{report}

% Process global keys
\ProcessKeyvalOptions{adsphd}

\AtEndOfClass{%

\AtBeginDocument{%
  % disable these options such that they cannot be used in the
  % \adsphdsetup command
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{cropmarks}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{cam}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{frame}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{10pt}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{11pt}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{12pt}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{oneside}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{twoside}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{draft}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{croppedpdf}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{tothejury}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{final}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{cover}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{british}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{showlabels}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{coverfontpercent}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{doctoralschool}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{faculty}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{department}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{phddegree}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{bleed}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{epub}

  \ifadsphd@nohyperref\else
    \hypersetup{%
      pdfauthor={\@authorf~\@authorl},%
      pdftitle={\@title},%
      pdfsubject={\@title},%
      pdfkeywords={phd, thesis, dissertation, doctoraat, kuleuven, \@authorf~\@authorl\gitaskeyword}%
    }
  \fi

  \ifcsname tikzifexternalizing\endcsname%
    \tikzifexternalizing{
      \typeout{Tikz externalize is running, disable cropping}
      \crop[off]
    }{}%
  \fi
}}

\RequirePackage{etoolbox}
\AtEndPreamble{%
  \ifadsphd@showlabels
    \typeout{adsphd.cls: [showlabels]}
    \RequirePackage{showlabels}
  \fi
}

\newcommand*{\adsphdsetup}{%
  \setkeys{adsphd}%
}

% Global keys (these options can only be set when calling the class)
\ifadsphd@nohyperref\else
  \ifpdf
    \PassOptionsToPackage{plainpages=false,pdfpagelabels,bookmarks,breaklinks,pdfborder={0 0 0}}{hyperref}
  \else
    \PassOptionsToPackage{plainpages=false,pdfpagelabels,ps2pdf,bookmarks,breaklinks,pdfborder={0 0 0}}{hyperref}
  \fi
\fi

% Various output options
\ifadsphd@epub
  \adsphd@framefalse
  \adsphd@cropmarksfalse
  \adsphd@camfalse
  \adsphd@infofalse
  \adsphd@showgitfalse
  \adsphd@croppedpdffalse
  %\crop[off]
\fi


\ifadsphd@bleed
  \setlength{\lbleed}{\defaultlbleed}
  \setlength{\rbleed}{\defaultrbleed}
  \setlength{\tbleed}{\defaulttbleed}
  \setlength{\bbleed}{\defaultbbleed}
\fi

\ifadsphd@print
  \adsphd@colorlinksfalse
  \adsphd@finaltrue
\fi

\ifadsphd@online
  \adsphd@colorlinkstrue
  \adsphd@finaltrue
\fi

\ifadsphd@final
  \typeout{Creating true page size pdf!}
  \adsphd@infofalse
  \adsphd@showinstructionsfalse
  \adsphd@showlabelsfalse
  %\adsphd@cropmarksfalse
  \adsphd@croppedpdftrue
  \adsphd@tothejuryfalse
\fi

\ifadsphd@tothejury
  \typeout{Creating A4 output for the version to send to the jury!!!}
  \adsphd@infofalse
  \adsphd@showinstructionsfalse
\fi

\ifadsphd@draft
  \typeout{adsphd.cls: [draft]}  
  \PassOptionsToClass{draft}{report}
  \adsphd@showlabelstrue
  % Show a frame around each logical
  \adsphd@frametrue
\fi

\ifadsphd@info
  \adsphd@frametrue
\else
  \PassOptionsToPackage{noinfo}{crop}
\fi


\ifadsphd@cover
  \PassOptionsToPackage{center}{crop}
\else
\ifadsphd@croppedpdf
  \adsphd@framefalse
  \newlength{\adsphdpaperwidthtotal}
  \setlength{\adsphdpaperwidthtotal}{\adsphdpaperwidth}
  \addtolength{\adsphdpaperwidthtotal}{\lbleed}
  \addtolength{\adsphdpaperwidthtotal}{\rbleed}
  \newlength{\adsphdpaperheighttotal}
  \setlength{\adsphdpaperheighttotal}{\adsphdpaperheight}
  \addtolength{\adsphdpaperheighttotal}{\tbleed}
  \addtolength{\adsphdpaperheighttotal}{\bbleed}
  \typeout{adsphd.cls: Cropped pdf selected!!! (\the\adsphdpaperwidthtotal,\the\adsphdpaperheighttotal)}
  \PassOptionsToPackage{width=\the\adsphdpaperwidthtotal,%
      height=\the\adsphdpaperheighttotal}{crop}
\fi
\fi

\ifadsphd@cropmarks
  \adsphd@camtrue
\fi
\ifadsphd@cam
  \typeout{adsphd.cls: [cam]}
  \adsphd@framefalse
  \PassOptionsToPackage{cam}{crop}
\fi

\ifadsphd@frame
  \typeout{adsphd.cls: [frame]}
  \PassOptionsToPackage{frame}{crop}
\fi

\ifadsphd@nohyperref\else
  \ifadsphd@colorlinks
    \definecolor{darkblue}{rgb}{0,0,0.55}
    \PassOptionsToPackage{colorlinks=true,linkcolor=darkblue,citecolor=darkblue,urlcolor=darkblue}{hyperref}
  \else
    \message{adsphd.cls: No colored links}
    \PassOptionsToPackage{colorlinks=false}{hyperref}
  \fi
\fi

\ifadsphd@cover
  \PassOptionsToPackage{a3,landscape}{crop}
\else
  \PassOptionsToPackage{a4}{crop}
\fi

\ifadsphd@showgit
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{showgit}
  \def\gittmpfile{/tmp/gitdescribe.txt} 
  \immediate\write18{touch \gittmpfile} 
  % Check whether shell escapes are enabled 
  \IfFileExists{\gittmpfile}{\shellescapetrue}{\shellescapefalse} 
  \ifshellescape 
    \adsphd@showgittrue
    %\newcommand*\cropgitinfo{\gitdescribe}
    \immediate\write18{git describe --tags --long --always > \gittmpfile} %
    \openin1=\gittmpfile
    \read1 to \gitdescribe
    \closein2
    \immediate\write18{rm \gittmpfile}%
  \else
    \message{Warning: Shell Escapes are not enabled. Run (pdf)latex with the `-shell-escape' option.}
    \IfFileExists{VERSION}{%
      \adsphd@showgittrue
      \openin1=VERSION
      \read1 to \gitdescribe
      \closein2
      \message{Warning: Fallback on VERSION file for print git information. (Create such a file with a git-hook)}
    }{%
      \adsphd@showgitfalse
      \message{Warning: Also no VERSION file found. Git information will not be shown.}
    }
  \fi
\fi
\ifadsphd@showgit
  \edef\gitaskeyword{ , \gitdescribe}
\else
  \def\gitaskeyword{}
\fi

\newcommand{\fulfillment}{fulfillment} % American english
\ifadsphd@british
  % In British english, this would be fulfilment...
  % [http://dictionary.cambridge.org/dictionary/british/fulfilment_1#fulfilment_1__3]
  \renewcommand{\fulfillment}{fulfilment}
\fi

\providecommand*\adsphd@cfgfile{adsphd.cfg}
\ifx\adsphd@cfgfile\@empty\else
  \InputIfFileExists\adsphd@cfgfile{}{\adsphd@error{%
      Configuration file `\adsphd@cfgfile' is not installed}}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now process the options passed to the packages

\LoadClass{report}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definitions of the input parameters

\RequirePackage{datatool}[2009/07/01]


% Allow for multiple supervisors
\DTLnewdb{supervisor}
\newcommand{\@supervisor}[2]{%
  \DTLnewrow{supervisor}%
  \DTLnewdbentry{supervisor}{name}{#1}%
  \DTLnewdbentry{supervisor}{affiliation}{#2}%
}
\newcommand{\@supervisorfirst}[2]{%
  \DTLforeach{supervisor}{}{\DTLremovecurrentrow}
  \let\supervisor\@supervisor
  \supervisor{#1}{#2}
}
\let\supervisor\@supervisorfirst


% Allow for multiple external jury members
\DTLnewdb{externaljury}
\newcommand{\@externaljurymember}[2]{%
  \DTLnewrow{externaljury}%
  \DTLnewdbentry{externaljury}{name}{#1}%
  \DTLnewdbentry{externaljury}{affiliation}{#2}%
}
\newcommand{\@externaljurymemberfirst}[2]{%
  \DTLforeach{externaljury}{}{\DTLremovecurrentrow}
  \let\externaljurymember\@externaljurymember
  \externaljurymember{#1}{#2}
}
\let\externaljurymember\@externaljurymemberfirst

\def\subtitle#1{\gdef\@subtitle{#1}}
\def\author#1#2{\gdef\@authorf{#1}\gdef\@authorl{#2}}
\def\president#1{\gdef\@president{#1}}
\def\jury#1{\gdef\@jury{#1}}
\def\udc#1{\gdef\@udc{#1}}
\def\depot#1{\gdef\@depot{#1}}
\def\isbn#1{\gdef\@isbn{#1}}
\def\rev#1{\gdef\@rev{#1}}
\gdef\@rev{}

\def\copyyear#1{\gdef\@copyyear{#1}}
\def\researchgroup#1{\gdef\@researchgroup{#1}}
\def\address#1{\gdef\@address{#1}}
\def\addresscity#1{\gdef\@addresspc{#1}}
\def\email#1{\gdef\@email{#1}}
\def\website#1{\gdef\@website{#1}}

% doctoral school
\ifx\@empty\adsphd@doctoralschool
\gdef\adsphd@doctoralschool{ads}
\fi

\ifcsdef{adsphd@doctoralschool@\adsphd@doctoralschool}{}{%
  \ClassError{adsphd}{Unsupported value '\adsphd@doctoralschool' for class option 'doctoralschool'}{\MessageBreak}}
\gdef\@doctoralschool{\expandafter\csname adsphd@doctoralschool@\adsphd@doctoralschool \endcsname}

% faculty
\ifcsdef{adsphd@faculty@\adsphd@faculty}{}{%
  \ClassError{adsphd}{Unsupported value '\adsphd@faculty' for class option 'faculty'}{\MessageBreak}}
\gdef\@faculty{\expandafter\csname adsphd@faculty@\adsphd@faculty \endcsname}

% department
\ifcsdef{adsphd@department@\adsphd@department}{}{%
  \ClassError{adsphd}{Unsupported value '\adsphd@department' for class option 'department'}{\MessageBreak}}
\gdef\@department{\expandafter\csname adsphd@department@\adsphd@department \endcsname}

% phddegree
\ifcsdef{adsphd@faculty@\adsphd@faculty @phddegree}{%
  \gdef\@phddegree{\expandafter\csname adsphd@faculty@\adsphd@faculty @phddegree\endcsname}}{%
  \ifcsdef{adsphd@faculty@\adsphd@faculty @phddegree@\adsphd@phddegree}{%
    \gdef\@phddegree{\expandafter\csname adsphd@faculty@\adsphd@faculty @phddegree@\adsphd@phddegree\endcsname}}{%
    \if\@empty\adsphd@phddegree%
      \ClassError{adsphd}{Required option 'phddegree' missing}{\MessageBreak}%
    \else
      \ClassError{adsphd}{Unsupported value '\adsphd@phddegree' for class option 'phddegree'}{\MessageBreak}
    \fi
  }%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Default values and other settings
\author{Guust}{Flater}
\@supervisor{Prof.dr.ir.~Supervisor}{}
\president{Mr.~De~Voorzitter}
\jury{Jurylid 1\\Jurylid 2}
\@externaljurymember{External jury member}{External affiliation}
\udc{}
\depot{}
\isbn{}

\researchgroup{Research group ...}
\address{Address ...}
\addresscity{B-3001 Leuven}
\title{Dissertation title ...}
\subtitle{}
\date{Month Year}
\copyyear{2014}
\email{first.name@dept.kuleuven.be}
\website{www.website.kuleuven.be}


% Default filename for custom cover page
\newcommand{\@customcoverpage}{mycoverpage.tex}

% Default title of chapter containing preface, abstract, publications,
% cv, ...  Note that the values below are merely suggestions. In
% practice only the string given in the \chapter{.} command in the
% included tex file will be used!
\newcommand{\prefname}{Preface}
\newcommand{\prefnlname}{Dankwoord}
\newcommand{\abstname}{Abstract}
\newcommand{\abstnlname}{Beknopte samenvatting}
\newcommand{\tocname}{Contents}
\newcommand{\pubname}{List of publications}
\newcommand{\cvname}{Curriculum vitae}
% The following _are_ used in practice as the contents of these
% chapters are generated automatically:
\renewcommand{\bibname}{Bibliography}
\newcommand{\lofname}{List of Figures}
\newcommand{\lotname}{List of Tables}
\newcommand{\lolname}{List of Listings}
\newcommand{\nomname}{Nomenclature}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now load a whole bunch of packages:

%\RequirePackage{showlabels}

\RequirePackage{listings}
\renewcommand{\lstlistlistingname}{\lolname}

\RequirePackage{framed} % voor shaded environment


% To easily change line spacing
\RequirePackage{setspace}


\ifadsphd@nohyperref\else
  \PassOptionsToPackage{hyphens}{url}
  \RequirePackage{hyperref}
\fi

% Page layout
%\RequirePackage[dvips=false,pdftex=false,vtex=false]{geometry} # Use this for older versions of geometry (e.g. on Karmic)
\RequirePackage[driver=none]{geometry}
\ifadsphd@epub
\geometry{
  papersize={4.5in, 6.2in},
  width=4.13in,
  height=5.83in,
  %vcenter,
  centering
}
\else
\geometry{
  paperwidth=\adsphdpaperwidth,
  paperheight=\adsphdpaperheight,
  width=120mm,
  height=180mm,
%  width=125mm, %ads
%  height=185mm, %ads
  left=20mm, % Equal margins on both sides: (paperwidth - width) / 2
}
\fi

\ifpdf
  \typeout{Using pdf}
  % Load the crop package
  \ifadsphd@epub\else
  \RequirePackage[center,pdftex]{crop}
  \fi
  \RequirePackage{graphicx}
  \DeclareGraphicsExtensions{.pdf, .jpg, .tif, .png}
  % Use utf-8 encoding for foreign characters
    \ifPDFTeX
      \RequirePackage[utf8]{inputenc}
    \fi
\else
  \typeout{Using DVIPS}
  % Load the crop package
  \RequirePackage[center,dvips]{crop} % Option [a3] already passed
  \RequirePackage[dvips]{graphicx}
  \DeclareGraphicsExtensions{.eps, .ps}
\fi

\RequirePackage[absolute]{textpos}

% Taken from ADS template  <--
\RequirePackage{placeins} % provides \FloatBarrier command

%\definecolor{gray}{rgb}{0.600,0.600,0.600}
\definecolor{gray}{cmyk}{0.0,0.0,0.0,0.500}

% TEXTPOS options
\setlength{\TPHorizModule}{1mm}
\setlength{\TPVertModule}{1mm}
\ifadsphd@cover%
\def\cleartextposbox{}%
\else%
\def\cleartextposbox{\global\setbox\TP@holdbox\vbox{}}%
\fi

% FONTS
\RequirePackage{microtype}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}  % to make pdf searchable
%\RequirePackage{textcomp} % nice greek alphabet
%\RequirePackage{pifont}   % Dingbats

\newcommand{\labfont}{\fontfamily{phv}\selectfont} % fonts used in labels
\usepackage{sectsty}
\allsectionsfont{\sffamily}
\DeclareMathAlphabet{\mathpzc}{OT1}{pzc}{m}{it}

% TABLE OF CONTENTS
\usepackage[titles]{tocloft}
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

\ifadsphd@showgit
  \ifadsphd@info
    \ifshellescape
      %\cropdef[\cropgitinfo]\CROP@@frame\relax\relax\relax{gitinfo}
      %\crop[gitinfo]
      \let\orig@CROP@time=\CROP@time
      \renewcommand{\CROP@time}{\orig@CROP@time\x\gitdescribe}
    \fi
  \fi
\fi

% PAGE CONTROL AND QUOTATION
\def\startchapter{
  \ifodd\count0
    \clearpage\thispagestyle{myheadings}\vspace*{\fill}\clearpage
  \else
    \vspace*{\fill}\clearpage\fi%
}

% HEADERS
\usepackage{fancyhdr}
\pagestyle{fancy}
% Make sure headers are uppercase
\renewcommand{\chaptermark}[1]{\markboth{\uppercase{#1}}{\uppercase{#1}}}
\renewcommand{\sectionmark}[1]{\markright{\uppercase{#1}}}
\fancyhf{}
\fancyhead[RO]{\scriptsize\sffamily\rightmark\ \hrulefill\ \thepage}
\fancyhead[RE]{\scriptsize\sffamily\thepage\ \hrulefill\ \leftmark}
\renewcommand{\headrulewidth}{0pt}
\fancypagestyle{plain}{
\fancyhf{}
\fancyfoot[C]{\scriptsize\sffamily\thepage}
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
%\def\vec#1{{\bf\bm{#1}}}

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
% Make sure babel does not overwrite our lof/lot name
\addto\captionsenglish{%
  \renewcommand\listfigurename{\lofname}
  \renewcommand\listtablename{\lotname}
}

% Conditionals
\RequirePackage{ifthen}

% Simple arithmetics with lengths
\RequirePackage{calc}

% Rotate textboxes etc.
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

% Set initial pagenumbering at the beginning to a,b,c...
% This is required to avoid warnings with pdflatex (see also
% http://en.wikibooks.org/wiki/LaTeX/Hyperlinks [Problems with Links
% and Pages]).
% In the course of the booklet, the numbering should be changed
% (resetted) only twice(!), i.e., using \frontmatter and \mainmatter.
\pagenumbering{alph} 

\newcommand{\frontmatter}{\cleardoublepage\pagenumbering{roman}}

\newcommand{\mainmatter}{\cleardoublepage\pagenumbering{arabic}}

\newcommand{\backmatter}{\cleardoublepage}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Commands for easy chapter inclusion

\def\chaptersdir{chapters}

% Create own chapter command based on the original \@chapter from
% report.cls:
%   - do not number the chapter
%   - include chapter in toc
%   - create headings
\def\@nonumberchapter[#1]#2{%
  \addcontentsline{toc}{chapter}{#1}%
  \chaptermark{#1}%
  \addtocontents{lof}{\protect\addvspace{10\p@}}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \if@twocolumn
    \@topnewpage[\vspace*{-\@chaptitlemoveup}%
        \@makeschapterhead{#2}]%
  \else
    \vspace*{-\@chaptitlemoveup}
    \@makeschapterhead{#2}%
    \@afterheading
  \fi
  \ifthenelse{\equal{\@chaptitlemoveup}{0mm}}{}{
    \setlength{\@chaptitlemoveup}{0mm}}
}
% The starred version is not included in the TOC (but headings are
% set!)
\def\@snonumberchapter#1{%
  \chaptermark{#1}%
  \addtocontents{lof}{\protect\addvspace{10\p@}}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \if@twocolumn
    \@topnewpage[\vspace*{-\@chaptitlemoveup}%
        \@makeschapterhead{#1}]%
  \else
    \vspace*{-\@chaptitlemoveup}
    \@makeschapterhead{#1}%
    \@afterheading
  \fi
  \ifthenelse{\equal{\@chaptitlemoveup}{0mm}}{}{
    \setlength{\@chaptitlemoveup}{0mm}}
}
\newlength{\@chaptitlemoveup}
\newcommand{\chaptitlemoveup}[1]{\setlength{\@chaptitlemoveup}{#1}}

\newcommand{\IncludeUnnumberedChapterIfExists}[4]{%
  \typeout{adsphd.cls: chapter `#1'}
  \cleardoublepage
  #4
  \IfFileExists{\chaptersdir/#1/#1.tex}{
    \let\orig@chapter=\chapter
    \renewcommand\chapter{\if@openright\cleardoublepage\else\clearpage\fi
      \thispagestyle{plain}%
      \global\@topnum\z@
      \@afterindentfalse
      \secdef\@nonumberchapter\@snonumberchapter}
    \include{\chaptersdir/#1/#1}
    \let\chapter=\orig@chapter
  }{
    \chapter*{#2}
    {\textcolor{red}{Input file \chaptersdir/#1/#1.tex does not exist. Make
    sure its starts with ``\textbackslash{}chapter\{#2\}''. To not
    include this chapter in the table of contents, use the starred
    version of the \textbackslash{}chapter command\ldots }}
    #3
  }
}

\newcommand{\includechapter}[1]{%
  \graphicspath{{\chaptersdir/#1/image/}}%
  %\cleardoublepage%
  \include{\chaptersdir/#1/#1}%
}

\newcommand{\includepreface}[1]{%
  \IncludeUnnumberedChapterIfExists{#1}{\prefname}{\instructionspreface}%
      {\phantomsection}
}

\newcommand{\includeprefacenl}[1]{%
  \selectlanguage{dutch}
  \IncludeUnnumberedChapterIfExists{#1}{\prefnlname}{\instructionspreface}
        {\phantomsection}
  \ifadsphd@british
  \selectlanguage{british}
  \else
  \selectlanguage{english}
  \fi
}

\newcommand{\includeabstract}[1]{%
  \IncludeUnnumberedChapterIfExists{#1}{\abstractname}{\instructionsabstract}
        {\phantomsection}
}

\newcommand{\includeabstractnl}[1]{%
  \selectlanguage{dutch}
  \IncludeUnnumberedChapterIfExists{#1}{\abstractnlname}{\instructionsabstract}
        {\phantomsection}
  \ifadsphd@british
  \selectlanguage{british}
  \else
  \selectlanguage{english}
  \fi
}

\newcommand{\includeabbreviations}[1]{%
  % Use this command when making the abbreviation manually. Using the
  \IncludeUnnumberedChapterIfExists{#1}{Abbreviations}{\instructionslistofsymbols}{}
}

\newcommand{\includenomenclature}[1]{%
  % Use this command when making the nomenclature manually. Using the
  % nomencl package might be a better idea though...
  \IncludeUnnumberedChapterIfExists{#1}{\nomname}{\instructionslistofsymbols}{}
}

\newcommand{\includebibliography}{%
  \cleardoublepage
  \phantomsection
  \addcontentsline{toc}{chapter}{\bibname}
}

\let\tableofcontentsorig\tableofcontents
\renewcommand{\tableofcontents}{%
  \cleardoublepage
  \phantomsection
  \addcontentsline{toc}{chapter}{\tocname}
  \microtypesetup{protrusion=false}
  \tableofcontentsorig
  \microtypesetup{protrusion=true}
}

\let\lstlistoflistingsorig\lstlistoflistings
\renewcommand{\lstlistoflistings}{%
  \cleardoublepage
  \phantomsection
  \addcontentsline{toc}{chapter}{\lolname}
  \let\tableofcontentsnew\tableofcontents
  \let\tableofcontents\tableofcontentsorig
  \lstlistoflistingsorig
  \let\tableofcontents\tableofcontentsnew
}

\let\listoffiguresorig\listoffigures
\renewcommand{\listoffigures}{%
  \cleardoublepage
  \phantomsection
  \addcontentsline{toc}{chapter}{\listfigurename}
  \listoffiguresorig
}

\let\listoftablesorig\listoftables
\renewcommand{\listoftables}{%
  \cleardoublepage
  \phantomsection
  \addcontentsline{toc}{chapter}{\lotname}
  \listoftablesorig
}

\newcommand{\includeappendix}[1]{%
  \typeout{adsphd.cls: chapter `#1'}
  \cleardoublepage
  \IfFileExists{\chaptersdir/#1/#1.tex}{
    \graphicspath{{\chaptersdir/#1/image/}}%
    \include{\chaptersdir/#1/#1}
  }{
    \chapter{#1}
    {\textcolor{red}{Input file \chaptersdir/#1/#1.tex does not exist.
    \instructionsappendices}}
  }
}

\newcommand{\includecv}[1]{%
  \IncludeUnnumberedChapterIfExists{#1}{\cvname}{\instructionscv}%
        {\phantomsection}
}

\newcommand{\includepublications}[1]{%
  \IncludeUnnumberedChapterIfExists{#1}{\pubname}%
        {\instructionslistofpublications}{\phantomsection}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Various utility commands

% 'Roman' references (the reference in 'Proposition 1.1' should be roman, not italics)
\def\@Rref#1{\hbox{\rm \ref{#1}}}
\def\Rref#1{\@Rref{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FTW instructions for each chapter

\newenvironment{ftw_instructions}{
  \definecolor{shadecolor}{gray}{0.85}
  \begin{shaded}
  \textbf{Instructies van de faculteit:} 
  
  }%
  {
    \end{shaded}
}

\newcommand{\instructionspreface}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
In het voorwoord wordt de algemene doelstelling van het werk samengevat in
enkele regels en worden personen, diensten of firma's bedankt voor hun
medewerking bij het tot stand komen van het werk.

De naam van firma's en personen uit deze firma's mogen slechts worden vermeld
mits hun uitdrukkelijke toelating \'en na overleg met de supervisor(en)!
Steeds wordt de supervisor(en) vermeld, de verantwoordelijke en eventueel de
personen die rechtstreeks geholpen hebben bv.\ door het ter beschikking stelling
van meetresultaten, faciliteiten.  Ook de instantie die eventueel een
doctoraatsbeurs heeft toegekend wordt bedankt (bv.\ FWO, IWT, \ldots).
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsabstract}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
In een beknopte tekst van maximum 2 pagina's worden de belangrijkste
doelstellingen en besluiten geformuleerd, zowel in het Nederlands als in het
Engels.  Zulke samenvattingen kunnen worden gebruikt in wetenschappelijke
verslagen van het departement of de faculteit.  Het Engels moet vlekkeloos zijn.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsnlsummary}{
  \ifadsphd@showinstructions
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
  \ifadsphd@showinstructions
\begin{ftw_instructions}
Lijst van gebruikte symbolen:
omvat de lijst van de belangrijkste gebruikte symbolen met indices, betekenis
en gebruikte eenheden.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionstableofcontents}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
Inhoudstafel: de inhoudstafel omvat de titels van hoofdstukken en paragrafen
met verwijzing naar de bladzijden.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsintroduction}{
  \ifadsphd@showinstructions
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
  \ifadsphd@showinstructions
\begin{ftw_instructions}
De hoofdstukken: Elk hoofdstuk is ingelast met een bepaald doel voor ogen.
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
  \ifadsphd@showinstructions
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
  \ifadsphd@showinstructions
\begin{ftw_instructions}
De bibliografie.
Departementale richtlijnen terzake te volgen.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionslistofpublications}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
Lijst van de publicaties door de doctorandus/a (auteur of co-auteur).
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionscv}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
Beknopt CV van de doctorandus.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsappendices}{
  \ifadsphd@showinstructions
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
%
% +-> For guidelines: http://set.kuleuven.be/phd/doc/guidelines_cover.pdf

\newcommand{\cropline}[4]{%
  \setlength{\unitlength}{1mm}
  \linethickness{.5pt}
  \setlength{\tmplength}{2mm}
  \setlength{\tmplength}{#3\tmplength}
  \typeout{the tmplenght \the\tmplength}
  \begin{textblock*}{0mm}(#1,#2+\tmplength)
  \ifthenelse{\equal{#3}{1}}{
    \begin{picture}(1,#4)(0,0)
      \put(0,0){\line(0,#3){#4}}
    \end{picture}
  }{
    \begin{picture}(1,-#4)(0,0)
      \put(0,0){\line(0,-#3){#4}}
    \end{picture}
  }
 \end{textblock*}
}

\newcommand{\useCustomCoverpageIfExists}{%
  \IfFileExists{\@customcoverpage}{%
    \typeout{adsphd.cls: Using custom cover page (\@customcoverpage)}
    \input{\@customcoverpage}
  }{
    \typeout{adsphd.cls: Cannot find custom cover page 
      (\@customcoverpage). Restoring default cover page.}
    \let\makefrontcovergeneralX\orig@makefrontcovergeneralX
    \let\makebackcovergeneralX\orig@makebackcovergeneralX

    \let\makefrontcovergeneralXII\orig@makefrontcovergeneralXII
    \let\makebackcovergeneralXII\orig@makebackcovergeneralXII
  }
}{}

\newcommand{\makefullcoverpage}[2]{%
  \typeout{Making full cover page}
  % #1: spinewidth
  % #2: spinetitlewidth
  \setlength{\lbleed}{\defaultlbleed}
  \setlength{\rbleed}{\defaultrbleed}
  \setlength{\adsphdspinewidth}{#1}

  \newlength{\skiplen}

  %\begin{textblock*}{\adsphdspinewidth+4pt}(\lbleed+\rbleed+\adsphdpaperwidth-2pt, 20mm)
  %\textblockcolour{}
  %\includegraphics[width=\adsphdspinewidth+4pt,height=20mm]{image/blue}
  %\end{textblock*}

  \setlength{\skiplen}{0mm+\rbleed}
  \makebackcovergeneralXII{\skiplen}{0}

  \setlength{\skiplen}{\lbleed+\rbleed+\adsphdpaperwidth}
  \makespinegeneralXII{\skiplen}{0}{#1}{#2}

  \setlength{\skiplen}{\rbleed+2\lbleed+\adsphdpaperwidth+\adsphdspinewidth}
  \makefrontcovergeneralXII{\skiplen}{0}

  % Draw some extra crop lines
  \cropline{\rbleed}{0mm}{-1}{5}
  \cropline{\rbleed+\adsphdpaperwidth}{0mm}{-1}{5}
  \cropline{\rbleed+\lbleed+\adsphdpaperwidth}{0mm}{-1}{10}
  \cropline{\rbleed+\lbleed+\adsphdpaperwidth+\adsphdspinewidth}{0mm}{-1}{10}
  \cropline{\rbleed+2\lbleed+\adsphdpaperwidth+\adsphdspinewidth}{0mm}{-1}{5}
  \cropline{\rbleed+2\lbleed+2\adsphdpaperwidth+\adsphdspinewidth}{0mm}{-1}{5}
  \cropline{\rbleed}{\adsphdpaperheight}{1}{5}
  \cropline{\rbleed+\adsphdpaperwidth}{\adsphdpaperheight}{1}{5}
  \cropline{\rbleed+\lbleed+\adsphdpaperwidth}{\adsphdpaperheight}{1}{10}
  \cropline{\rbleed+\lbleed+\adsphdpaperwidth+\adsphdspinewidth}{\adsphdpaperheight}{1}{10}
  \cropline{\rbleed+2\lbleed+\adsphdpaperwidth+\adsphdspinewidth}{\adsphdpaperheight}{1}{5}
  \cropline{\rbleed+2\lbleed+2\adsphdpaperwidth+\adsphdspinewidth}{\adsphdpaperheight}{1}{5}

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Provide front cover using the 2012 (XII) layout
% used by the Arenberg Doctoral School
\newcommand{\frontcoverheaderXII}[1]{%
  % Use Helvetica
  \renewcommand{\sfdefault}{\helvetsfdefault}
  \thispagestyle{empty}
  % Blue bar on top
  \begin{textblock*}{\adsphdpaperwidth+\lbleed+\rbleed}(0mm-\lbleed+#1,20mm)
  \textblockcolour{blueXIIdark}
  %\vspace{-\parskip}
  \rule{0pt}{20mm}
  \end{textblock*}
  %
  % Create logo box
  \begin{textblock*}{56mm}(10mm+#1,15mm)
  \includegraphics[width=56mm,height=20mm]{image/KULEUVEN_LOGO_2012}
  \end{textblock*}
  %
  % Create ADS+faculty box
  \begin{textblock*}{85mm}(70mm+#1,20mm)
  \textblockcolour{}
  \vspace{-\parskip}
  %\hspace*{2mm}
  \begin{flushright}
  \fontsize{12}{15}\selectfont
  \def\tmphss{hss}%
  \ifx\tmphss\adsphd@doctoralschool
  \typeout{adsphd: Cover, smaller font size to fit doctoral school name}
  \fontsize{10}{13}\selectfont%
  \fi
  {\bfseries \textcolor{white} {\sffamily \expandafter\MakeUppercase\expandafter{\@doctoralschool}}}\\[.2mm]
  {\sffamily \textcolor{white} {\@faculty}}
  \end{flushright}
  \end{textblock*}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Provide front cover using the 2010 (X) layout
% used by the Arenberg Doctoral School
\newcommand{\frontcoverheaderX}[1]{%
  % Use Helvetica
  \renewcommand{\sfdefault}{\helvetsfdefault}
  \thispagestyle{empty}
  % Now using \usepackage[absolute]{textpos}. The positioning become a lot
  % robuster this way wrt changes in margins etc.
  %
  % Put sedes at top center
  \begin{textblock*}{\adsphdpaperwidth}(0mm+#1,0mm)
  \textblockcolour{}
  \vspace{-\parskip}
  \begin{center}
  \includegraphics[width=8mm]{image/sedes}
  \end{center}
  \end{textblock*}
  %
  % Create gray box
  \begin{textblock*}{100mm+\rbleed}(60mm+#1,20mm)
  \textblockcolour{gray}
  \vspace{-\parskip}
  \hspace*{2mm}
  \parbox[c][20mm]{97.92mm}{
  {\bfseries \small \textcolor{white} {\sffamily Arenberg Doctoral School of Science, Engineering \& Technology}}\\[.2mm]
  {\sffamily\small \textcolor{white} {\@faculty}}\\[.2mm]
  {\sffamily\small \textcolor{white} {\@department}}
  }
  \end{textblock*}
  %
  % Create blue background 
  \begin{textblock*}{60mm+\lbleed}(0mm-\lbleed+#1, 20mm)
  \textblockcolour{}
  \includegraphics[width=60mm+\lbleed,height=20mm]{image/blue}
  \end{textblock*}
  %
  % Put KULeuven logo on top of the blue background
  \begin{textblock*}{60mm}(0mm+#1, 20mm)
  \textblockcolour{}
  %\vspace{-\parskip}
  \includegraphics*[height=20mm]{image/kullogo2}
  \end{textblock*}
}

\newcommand{\frontcoverfooterX}[1]{%
  % Only add empty pages if asked for
  \ifthenelse{\equal{#1}{1}}
  {
    \newpage
    \thispagestyle{empty} \mbox{}
    \newpage
  }{}
  %
  % Restore font
  \renewcommand{\sfdefault}{\origsfdefault}
}

\newcommand{\frontcoverfooterXII}[1]{%
  % Only add empty pages if asked for
  \ifthenelse{\equal{#1}{1}}
  {
    \newpage
    \thispagestyle{empty} \mbox{}
    \newpage
  }{}
  %
  % Restore font
  \renewcommand{\sfdefault}{\origsfdefault}
  % Empty textpos boxes (interferes with some other packages such as
  % Tikz externalize
  \cleartextposbox
}

\newcommand{\coverfontsize}[2]{%
  \count1=#1
  \count2=#2
  %\expandafter\message{COVERFONTSIZE: #1 #2 \adsphd@coverfontpercent}
  \multiply \count1 by \adsphd@coverfontpercent
  \divide \count1 by 100
  \multiply \count2 by \adsphd@coverfontpercent
  \divide \count2 by 100
  %\expandafter\message{COVERFONTSIZE: #1 #2 \the\count1\ \the\count2}
  \fontsize{\the\count1}{\the\count2}
}

\newcommand{\makefrontcoverXII}{\makefrontcovergeneralXII{0mm}{1}}
\ifadsphd@epub
  \renewcommand{\makefrontcoverXII}{}
\fi
\newcommand{\makefrontcovergeneralXII}[2]{%
  \typeout{adsphd.cls: Create cover with bleed (\the\rbleed,\the\lbleed)}
  %
  % Create header
  \frontcoverheaderXII{#1}
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
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
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  %
  % Place the DRAFT notifier on the front page to avoid printing a wrong
  % version
  \ifadsphd@final\else
    \begin{textblock*}{120mm}(17.5mm+#1,50mm)
    \textblockcolour{}
    \vspace{-\parskip}
    \begin{center}
        \selectfont\LARGE\sffamily\textbf{\color{red}{
            DRAFT\\
            {\small To remove, add `final' to class options}
        }}
    \end{center}
    \end{textblock*}
  \fi
  %
  % Place the title and subtitle
  %\typeout{Title position: 17.5mm+\the#1}
  \begin{textblock*}{135mm}(17.5mm+#1,100mm)
  \textblockcolour{}
  \vspace{-\parskip}
  \raggedright
  \coverfontsize{30}{34}\selectfont\sffamily{\color{blueXIIdark}\@title}\\
  \coverfontsize{20}{25}\selectfont\sffamily{\@subtitle}
  \end{textblock*}
  %
  % Place the author name
  \begin{textblock*}{135mm}(17.5mm+#1,170mm)
  \textblockcolour{}
  \vspace{-\parskip}
  \begin{flushright}
  \coverfontsize{14}{19}\selectfont\sffamily\textbf{\@authorf\ \@authorl}
  \end{flushright}
  \end{textblock*}
  %
  % Place the fullfilment text
  \begin{textblock*}{67.5mm}(85mm+#1,185mm)
  \textblockcolour{}
  \vspace{-\parskip}
  \begin{minipage}[t]{67mm}
  {\coverfontsize{12}{15}\selectfont\sffamily%
  \begin{flushright}
  Dissertation presented in partial\\%
  \fulfillment\ of the requirements for the\\%
  degree of \@phddegree
  \end{flushright}
  }
  \end{minipage}
  \end{textblock*}
  %
  % Place the date text
  \begin{textblock*}{67.5mm}(85mm+#1,220mm)
  \textblockcolour{}
  \vspace{-\parskip}
  \begin{minipage}[t]{67mm}
  \begin{flushright}
  {\coverfontsize{12}{15}\selectfont\sffamily\@date}
  \end{flushright}
  \end{minipage}
  \end{textblock*}
  %
  % Place the Examination committee text
  \ifadsphd@covershowcommittee
    \begin{textblock*}{67.5mm}(17.5mm+#1,185mm)
    \textblockcolour{}
    \vspace{-\parskip}
    \begin{minipage}[t]{67mm}
      \coverfontsize{12}{15}\selectfont\sffamily
      %\begin{tabular}[t]{p{6.9cm}}
      Examination committee:\\
      \@president, chair
      \DTLforeach{supervisor}{\name=name,\affiliation=affiliation}{%
      \\\name, supervisor
      \ifthenelse{\equal{\affiliation}{}}{}{%
        \\\rule{0.25cm}{0pt}(\affiliation)
      }}
      %\DTLforeach{cosupervisor}{\name=name,\affiliation=affiliation}{%
      %\\\name%, co-supervisor
      %\ifthenelse{\equal{\affiliation}{}}{}{%
        %\\\rule{0.25cm}{0pt}(\affiliation)
      %}}
      \\\@jury%
      \DTLforeach{externaljury}{\name=name,\affiliation=affiliation}{%
      \\\name \\
      \rule{0.25cm}{0pt}(\affiliation)
      }
      \\
      \if\empty\@udc \else U.D.C. \@udc\fi
    %\end{tabular}
    \end{minipage}
    \end{textblock*}
  \else
    \begin{textblock*}{67.5mm}(17.5mm+#1,185mm)
    \textblockcolour{}
    \vspace{-\parskip}
    \begin{minipage}[t]{67mm}
      \coverfontsize{12}{15}\selectfont\sffamily
      %\begin{tabular}[t]{p{6.9cm}}
      \dtlifnumlt{\DTLrowcount{supervisor}}{2}{Supervisor:}{Supervisors:}
      \DTLforeach{supervisor}{\name=name,\affiliation=affiliation}{%
      \\\name
      \ifthenelse{\equal{\affiliation}{}}{}{%
        \\\rule{0.25cm}{0pt}(\affiliation)
      }}
      %\DTLforeach{cosupervisor}{\name=name,\affiliation=affiliation}{%
      %\\\name%, co-supervisor
      %\ifthenelse{\equal{\affiliation}{}}{}{%
        %\\\rule{0.25cm}{0pt}(\affiliation)
      %}}
      \\
      \if\empty\@udc \else U.D.C. \@udc\fi
    %\end{tabular}
    \end{minipage}
    \end{textblock*}
  \fi
  %
  % Bottom blue bar
  \begin{textblock*}{\adsphdpaperwidth+\lbleed+\rbleed}(0mm-\lbleed+#1,234mm)
  \textblockcolour{blueXIIlight}
  %\vspace{-\parskip}
  \rule{0pt}{2.1mm}
  \end{textblock*}
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  %
  % Add footer
  \frontcoverfooterXII{#2}
}

\newcommand{\makefrontcoverX}{\makefrontcovergeneralX{0mm}{1}}
% \makefrontcovergeneralX{xskip}{}clearpage
\newcommand{\makefrontcovergeneralX}[2]{%
\typeout{adsphd.cls: Using default front cover page}
  %
  % Create header
  \frontcoverheaderX{#1}
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
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
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  %
  % Place the DRAFT notifier on the front page to avoid printing a wrong
  % version
  \ifadsphd@final\else
    \begin{textblock*}{120mm}(17.5mm+#1,90mm)
    \textblockcolour{}
    \vspace{-\parskip}
    \begin{center}
        \selectfont\LARGE\sffamily\textbf{\color{red}{
            DRAFT\\
            {\small To remove, add `final' to class options}
        }}
    \end{center}
    \end{textblock*}
  \fi
  %
  % Place the title
  \begin{textblock*}{120mm}(17.5mm+#1,112.5mm)
  \textblockcolour{}
  \vspace{-\parskip}
  \raggedright\selectfont\LARGE\sffamily\textbf{\@title}
  \end{textblock*}
  %
  % Place the subtitle
  \begin{textblock*}{120mm}(17.5mm+#1,132mm)
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
  \fulfillment\ of the requirements for\\
  the degree of \@phddegree}
  \end{textblock*}
  %
  % Place date
  \begin{textblock*}{\adsphdpaperwidth}(0mm+#1,221.5mm)
  \textblockcolour{}
  \vspace{-\parskip}
  \begin{center} {\small\sffamily\@date }\end{center}
  \end{textblock*}
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  %
  % Add footer
  \frontcoverfooterX{#2}

}

\let\orig@makefrontcovergeneralX\makefrontcovergeneralX
\let\orig@makefrontcovergeneralXII\makefrontcovergeneralXII

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redefine title page
\renewcommand{\maketitle}{%
\cleardoublepage
\thispagestyle{empty} \mbox{}

%\begin{textblock}{120}(0,37.5)
\begin{textblock}{120}(17.5,70)
\textblockcolour{}
\vspace{-\parskip}
\begin{flushleft}
\Large\sffamily\textbf{\@title}
\end{flushleft}
\end{textblock}
%
%\begin{textblock}{120}(0,47.5)
\begin{textblock}{120}(17.5,85.0)
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
    Examination committee:\\
    \@president, chair
    \DTLforeach{supervisor}{\name=name,\affiliation=affiliation}{%
    \\\name, supervisor
    \ifthenelse{\equal{\affiliation}{}}{}{%
      \\\rule{0.25cm}{0pt}(\affiliation)
    }}
    %\DTLforeach{cosupervisor}{\name=name,\affiliation=affiliation}{%
    %\\\name%, co-supervisor
    %\ifthenelse{\equal{\affiliation}{}}{}{%
      %\\\rule{0.25cm}{0pt}(\affiliation)
    %}}
    \\\@jury%
    \DTLforeach{externaljury}{\name=name,\affiliation=affiliation}{%
    \\\name \\
    \rule{0.25cm}{0pt}(\affiliation)
    }
    \\
    \if\empty\@udc \else U.D.C. \@udc\fi
%  \end{tabular}
\end{minipage}
\begin{minipage}[t]{5.3cm}
%  \begin{tabular}[t]{l}
    Dissertation presented in partial
    \fulfillment\ of the requirements for
    the degree of \@phddegree
%  \end{tabular}
\end{minipage}

%\begin{tabular}{p{7cm}l}
% Jury:                                                   & Dissertation presented in partial
% \@president, president                                  & fulfillment of the requirements for
% \@supervisor, supervisor                                & the degree of \@phddegree
% titles first name last name                             & \\
% titles first name last name                             & \\
%   \rule{0.25cm}{0pt}(external affiliation)              & \\
%                                                         & \\
% U.D.C. \@udc
%\end{tabular}
\end{textblock}
%\vfill
%\begin{center} {\@date} \end{center}
\begin{textblock}{160}(0,210.0)
\textblockcolour{}
\vspace{-\parskip}
\begin{center} \@date \end{center}
\end{textblock}
% NEW PAGE
%\pagenumbering{roman}
\newpage
\thispagestyle{empty}
\mbox{}
\vfill
{\scriptsize\sffamily{\setlength{\parindent}{0ex}\copyright{}~\@copyyear~KU Leuven -- \@faculty \\
Uitgegeven in eigen beheer, \@authorf~\@authorl, \@address, \@addresspc{} (Belgium)}

\bigskip
\selectlanguage{dutch}
Alle rechten voorbehouden. Niets uit deze uitgave mag worden vermenigvuldigd en/of openbaar gemaakt
worden door middel van druk, fotokopie, microfilm, elektronisch
of op welke andere wijze ook zonder voorafgaande schriftelijke
toestemming van de uitgever.

\medskip
\ifadsphd@british
\selectlanguage{british}
\else
\selectlanguage{english}
\fi
All rights reserved. No part of the publication may be reproduced
in any form by print, photoprint, microfilm, electronic or any other means
without written permission from the publisher.

\medskip

\ifthenelse{\equal{\@isbn}{}}{}{ISBN \@isbn\\}
\ifthenelse{\equal{\@depot}{}}{}{D/\@depot}
}
%\vspace{1cm}

\cleardoublepage
\cleartextposbox
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Provide back cover using the 2010 (X) layout
% used by the Arenberg Doctoral School
\newcommand{\backcoverheaderX}[2]{%
  \typeout{adsphd.cls: Using default back cover page}
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
  \begin{textblock*}{152.5mm+\rbleed}(-\rbleed+#1,20mm)
  \textblockcolour{gray}
  \vspace{-\parskip}
  \parbox[c][20mm]{151.2mm+\rbleed}{
  \flushright
  \vspace{-3mm}
  {\bfseries \scriptsize \textcolor{white} {\sffamily{}Arenberg Doctoral School of Science, Engineering \& Technology} \ \ }\\[-1mm]
  {\scriptsize \textcolor{white} {\sffamily\@faculty\ \ }}\\[-1.2mm]
  {\scriptsize \textcolor{white} {\sffamily\@department \ \ }}\\[-1.2mm]
  {\scriptsize \textcolor{white} {\sffamily\@researchgroup\ \ }}\\[-1.2mm]
  {\scriptsize \textcolor{white} {\sffamily\@address\ \ }}\\[-1.2mm]
  {\scriptsize \textcolor{white} {\sffamily{}\@addresspc\ \ }}
  }
  \end{textblock*}
  %
  %
  % Create blue background
  \setlength{\tmplength}{\adsphdpaperwidth}
  \addtolength{\tmplength}{-152mm}
  \addtolength{\tmplength}{\rbleed}
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
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Provide back cover using the 2012 (XII) layout
% used by the Arenberg Doctoral School
\newcommand{\backcoverheaderXII}[2]{%
  \typeout{adsphd.cls: Using default XII back cover page}
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

  % Blue lines in right corner
  %
  \begin{textblock*}{55mm}(#1+97.5mm,20mm)
  \textblockcolour{blueXIIlight}
  %\vspace{-\parskip}
  \rule{0pt}{2mm}
  \end{textblock*}
  \begin{textblock*}{2mm}(#1+152mm,20mm)
  \textblockcolour{blueXIIlight}
  %\vspace{-\parskip}
  \rule{0pt}{18mm}
  \end{textblock*}
  %
  % Create gray box
  \begin{textblock*}{137.5mm}(#1,23mm)
  \textblockcolour{}
  \vspace{-\parskip}
  %\parbox[c][20mm]{151.2mm+\rbleed}{
  \flushright
  %\vspace{-3mm}
  {\scriptsize {\sffamily\MakeUppercase\@faculty}}\\[-1mm]
  {\scriptsize {\sffamily\MakeUppercase\@department}}\\[-1mm]
  {\scriptsize {\sffamily\MakeUppercase\@researchgroup}}\\[-1mm]
  {\scriptsize {\sffamily\@address}}\\[-1mm]
  {\scriptsize {\sffamily{}\@addresspc}}\\[-1mm]
  \ifdefempty{\@email}{}{{\scriptsize {\sffamily{}\@email}}\\[-1mm]}
  \ifdefempty{\@website}{}{{\scriptsize {\sffamily{}\@website}}}
  %}
  \end{textblock*}
  %
  %
  % Create blue background
  %\setlength{\tmplength}{\adsphdpaperwidth}
  %\addtolength{\tmplength}{-152mm}
  %\addtolength{\tmplength}{\rbleed}
  %\begin{textblock*}{\tmplength}(152.0mm+#1,20mm)
  %\textblockcolour{}
  %\includegraphics[width=\tmplength,height=20mm]{image/blue}%
  %\end{textblock*}
  %
  % Put KULeuven sedes on top
  \begin{textblock*}{7mm}(140mm+#1,24mm)
  \textblockcolour{}
  \vspace{-\parskip}
  \includegraphics*[height=15mm]{image/sedes}%
  \end{textblock*}
}

\newcommand{\backcoverfooterX}[1]{%
  % Put logo of the association at the bottom right
  \begin{textblock*}{7mm}[2.,1.](150mm+#1,231.0mm)
  \textblockcolour{}
  \vspace{-\parskip}
  \includegraphics*[height=20mm]{image/ASSO_ZEGEL_ZW}
  \end{textblock*}
  %
  % Restore font
  \renewcommand{\sfdefault}{\origsfdefault}
}

\newcommand{\backcoverfooterXII}[1]{%
  % Bottom blue bar
  %\begin{textblock*}{\adsphdpaperwidth}(#1,222mm)
  \begin{textblock*}{\adsphdpaperwidth+\lbleed+\rbleed}(#1-\rbleed,222mm)
  %\begin{textblock*}{\adsphdpaperwidth}(0mm+#1,234mm)
  \textblockcolour{blueXIIdark}
  %\vspace{-\parskip}
  \rule{0pt}{15mm}
  \end{textblock*}
  %
  % Restore font
  \renewcommand{\sfdefault}{\origsfdefault}
}

\newcommand{\makebackcoverXII}{\makebackcovergeneralXII{0mm}{1}}
\ifadsphd@epub
  \renewcommand{\makebackcoverXII}{}
\fi
% \makebackcovergeneralXII{xskip}{clearpage}
\newcommand{\makebackcovergeneralXII}[2]{%
\typeout{adsphd.cls: Using default back cover page}
  %
  % Create header
  \backcoverheaderXII{#1}{#2}
  %
  % Add footer
  \backcoverfooterXII{#1}
}

\newcommand{\makebackcoverX}{\makebackcovergeneralX{0mm}{1}}
% \makebackcovergeneralX{xskip}{clearpage}
\newcommand{\makebackcovergeneralX}[2]{%
\typeout{adsphd.cls: Using default back cover page}
  %
  % Create header
  \backcoverheaderX{#1}{#2}
  %
  % Add footer
  \backcoverfooterX{#1}
}

\let\orig@makebackcovergeneralX\makebackcovergeneralX
\let\orig@makebackcovergeneralXII\makebackcovergeneralXII

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the spine of the booklet
\newlength{\defaultspinetitlewidth}
\setlength{\defaultspinetitlewidth}{90mm}

\newlength{\spinetitlewidth}
\setlength{\spinetitlewidth}{\defaultspinetitlewidth}

%\newcommand{\makespine}[2]{\makespinegeneralX{xskip}{clearpage}{spinewidth}{spinetitlewidth}}
\newcommand{\makespine}[2]{\makespinegeneralX{0mm}{1}{#1}{#2}}
\newcommand{\makespinegeneralX}[4]{%
  % Use Helvetica
  \renewcommand{\sfdefault}{\helvetsfdefault}
  %
  % Get adsphdspinewidth as #3
  \setlength{\adsphdspinewidth}{#3}
  % 
  % Get spinetitlewidth as #4
  \ifthenelse{\equal{#4}{}}
  {}{
    \setlength{\spinetitlewidth}{#4}
  }
  %
  % Empty pagestyle
  \thispagestyle{empty}%
  %
  % Only clear page if asked for
  \ifthenelse{\equal{#2}{1}}
  {
    \cleardoublepage \mbox{}%
  }{}
  %
  % Create blue box
  \begin{textblock*}{\adsphdspinewidth}(0mm+#1,20mm)
  \textblockcolour{}
  \vspace{-\parskip}
  \includegraphics[width=\adsphdspinewidth,height=20mm]{image/blue}%
  \end{textblock*}
  %
  \newlength{\authorlen}
  \settowidth{\authorlen}{\large\sffamily\@authorf\ \MakeUppercase\@authorl}
  \newlength{\authorlenpenalty}
  \ifthenelse{\lengthtest{\authorlen>4.2cm}}{%
      % For really really long names, move the name up a bit more
      \typeout{adsphd.cls: Really long author name detected in %
        generation of spine. Moving it up by 4mm.}
      \setlength{\authorlenpenalty}{4mm}
  }{%
    \ifthenelse{\lengthtest{\authorlen>4.0cm}}{%
      % For really long names, move the name up a bit
      \typeout{adsphd.cls: Long author name detected in generation of %
        spine. Moving it up by 3mm.}
      \setlength{\authorlenpenalty}{3mm}
    }{%
    \setlength{\authorlenpenalty}{0mm}
    }
  }
  %
  \begin{textblock*}{\adsphdspinewidth}(0mm+#1,49mm-\authorlenpenalty) % 9mm whitespace 
                                        % between blue and first letter of the author name
                                        % (possibly less because the author name might be
                                        % reallyreally long)
  \textblockcolour{}
  % Rotate the text
  \begin{turn}{-90}
  \makebox[\adsphdpaperheight-56mm+\authorlenpenalty][c]{% 20mm(white)+20mm(blue)+9mm(space before name)+7mm(after date)
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

  \renewcommand{\sfdefault}{\origsfdefault}
}

\newcommand{\makespinegeneralXII}[4]{%
  % Use Helvetica
  \renewcommand{\sfdefault}{\helvetsfdefault}
  %
  % Get adsphdspinewidth as #3
  \setlength{\adsphdspinewidth}{#3}
  % 
  % Get spinetitlewidth as #4
  \ifthenelse{\equal{#4}{}}
  {}{
    \setlength{\spinetitlewidth}{#4}
  }
  %
  % Empty pagestyle
  \thispagestyle{empty}%
  %
  % Only clear page if asked for
  \ifthenelse{\equal{#2}{1}}
  {
    \cleardoublepage \mbox{}%
  }{}
  %
  \newlength{\authorlen}
  \settowidth{\authorlen}{\large\sffamily\@authorf\ \MakeUppercase\@authorl}
  \newlength{\authorlenpenalty}
  \ifthenelse{\lengthtest{\authorlen>4.2cm}}{%
      % For really really long names, move the name up a bit more
      \typeout{adsphd.cls: Really long author name detected in %
        generation of spine. Moving it up by 4mm.}
      \setlength{\authorlenpenalty}{4mm}
  }{%
    \ifthenelse{\lengthtest{\authorlen>4.0cm}}{%
      % For really long names, move the name up a bit
      \typeout{adsphd.cls: Long author name detected in generation of %
        spine. Moving it up by 3mm.}
      \setlength{\authorlenpenalty}{3mm}
    }{%
    \setlength{\authorlenpenalty}{0mm}
    }
  }
  %
  \begin{textblock*}{\adsphdspinewidth}(0mm+#1,20mm-\authorlenpenalty) % 9mm whitespace 
                                        % between blue and first letter of the author name
                                        % (possibly less because the author name might be
                                        % reallyreally long)
  \textblockcolour{}
  % Rotate the text
  \begin{turn}{-90}
  \makebox[\adsphdpaperheight-24mm+\authorlenpenalty][c]{% 20mm(white)+20mm(blue)+9mm(space before name)+7mm(after date)
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

  \renewcommand{\sfdefault}{\origsfdefault}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\setcustomcoverpage#1{%
  \gdef\@customcoverpage{#1}
  \typeout{adsphd.cls: Setting new custom cover page (#1)}
  \useCustomCoverpageIfExists
}

% Use own version of the cover page
\useCustomCoverpageIfExists

\endinput
%%
%% End of file `adsphd.cls'.
%% vim: tw=70 expandtab
