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

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{adsphd}
    [2010/02/02 v0.1 Standard K.U.Leuven Arenberg Doctoral School PhD class]

\newif\ifshowtodo
\newif\ifshowinstructions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Options that can be passed to adsphd.cls:

% Show a frame around each logical page by default
\PassOptionsToPackage{frame}{crop}

% Default options to report class, taken from the ADS template <--
\PassOptionsToClass{fleqn,10pt,twoside}{report}
\PassOptionsToPackage{ps2pdf,bookmarks,breaklinks,pdfborder={0 0 0}}{hyperref}
% --> end ADS 

% Nice colored links in the pdf
\PassOptionsToPackage{colorlinks=true}{hyperref}

% Control backward referencing of in bibliography
\DeclareOption{backref}{%
  \PassOptionsToClass{backref}{hyperref}
}

\DeclareOption{pagebackref}{%
  \PassOptionsToClass{pagebackref}{hyperref}
}

% Draft
\DeclareOption{draft}{%
  \PassOptionsToClass{draft}{report}
  \PassOptionsToPackage{frame}{crop}
}

\DeclareOption{prelim}{%
  \PassOptionsToPackage{frame}{crop}
}

% Final document should be a pdf on true size
\DeclareOption{croppedpdf}{%
  \typeout{Cropped pdf selected!!!}
  \PassOptionsToPackage{off,noinfo}{crop}
  % From ADS <--
%  \PassOptionsToPackage{pdfpagescrop={92 75 546 750}}{hyperref} % original version
  % --> end ADS
  % Adapted to reflect the centering by the crop package
  \PassOptionsToPackage{pdfpagescrop={71 81 524 761}}{hyperref}
}

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

\DeclareOption{showinstructions}{%
  \showinstructionstrue
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

% Default values
\author{Guust}{Flater}
\promotor{Prof.~Promotor}
\president{Mr.~De~Voorzitter}
\jury{Jurylid 1\\Jurylid 2}
\externaljurymember{External jury member}
\externalaffiliation{External affiliation}
\udc{XXX.XX}
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now load a whole bunch of packages:

% Een aantal packages uit de cls van Bart
%\RequirePackage{xcolor}
\RequirePackage{framed} % voor shaded environment
%
%\RequirePackage{nomencl}
%\renewcommand{\nomname}{List of Symbols}
%
%\RequirePackage{makeidx}

% Taken from ADS <--
\RequirePackage{hyperref}
\RequirePackage[usenames]{color}
% <-- end ADS

% Page layout
\RequirePackage[dvips=false,pdftex=false,vtex=false]{geometry}
\geometry{
  paperwidth=160mm,
  paperheight=240mm,
  width=120mm, %bart
  height=175mm, %bart
%  width=125mm, %ads
%  height=185mm, %ads
  left=20mm, % Equal margins on both sides: (paperwidth - width) / 2
}

% Load the crop package
\RequirePackage[a4,center,dvips]{crop}

\RequirePackage[dvips]{graphicx}
\RequirePackage[absolute]{textpos}

% Taken from ADS template  <--
\RequirePackage{placeins} % provides \FloatBarrier command
% TEXTPOS options
\definecolor{gray}{rgb}{0.600,0.600,0.600}

\setlength{\TPHorizModule}{1mm}
\setlength{\TPVertModule}{1mm}

% FONTS
\usepackage{microtype}
%\usepackage[T1]{fontenc}
\usepackage{lmodern}
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
  \selectlanguage{dutch}
  \IfFileExists{\chaptersdir/#1/#1.tex}{
    \include{\chaptersdir/#1/#1}
  }{
    \chapter*{Preface}
    {\textcolor{Red}{Input file \chaptersdir/#1/#1.tex does not exist. Make
    sure its starts with "\textbackslash{}chapter*\{Preface\}"\ldots }}
    \instructionsforeword
  }
}

\newcommand{\includeabstract}[1]{%
  \selectlanguage{english}
  \cleardoublepage
  \IfFileExists{\chaptersdir/#1/#1.tex}{
    \include{\chaptersdir/#1/#1}
  }{
    \chapter*{Abstract}
    {\textcolor{Red}{Input file \chaptersdir/#1/#1.tex does not exist. Make
    sure it starts with "\textbackslash{}chapter*\{Abstract\}"\ldots}}
    \instructionsabstract
  }
}

\newcommand{\includenomenclature}[1]{%
  \IfFileExists{\chaptersdir/#1/#1.tex}{
    \include{\chaptersdir/#1/#1}
  }{
    \chapter*{Nomenclature}
    {\textcolor{Red}{Input file \chaptersdir/#1/#1.tex does not exist. Make
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
  \bibliographystyle{plain}
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
    {\textcolor{Red}{Input file \chaptersdir/#1/#1.tex does not exist.}}
    \instructionsappendices
  }
}

\newcommand{\includecv}[1]{%
  \cleardoublepage
  {
  \def\rightmark{CURRICULUM VITAE}
  \def\leftmark{CURRICULUM VITAE}
  \addcontentsline{toc}{chapter}{Curriculum vitae}
  \cleardoublepage
  \IfFileExists{\chaptersdir/#1/#1.tex}{
    \include{\chaptersdir/#1/#1}
  }{
    \chapter*{Curriculum vitae}
    {\textcolor{Red}{Input file \chaptersdir/#1/#1.tex does not exist. Make
    sure it starts with "\textbackslash{}chapter*\{Curriculum vitae\}"\ldots}}
    \instructionscv
  }
  }%
}

\newcommand{\includepublications}[1]{%
  {
    \addcontentsline{toc}{chapter}{}
    \IfFileExists{\chaptersdir/#1/#1.tex}{
      \includechapter{\chaptersdir/#1/#1}
    }{
      \cleardoublepage
      \chapter{List of publications}
      {\textcolor{Red}{Input file \chaptersdir/#1/#1.tex does not exist. Make
      sure it starts with "\textbackslash{}chapter*\{List of publications\}"\ldots}}
      \instructionslistofpublications
    }
  }%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Various utility commands
\newcommand{\todo}[1]{%
  \ifshowtodo
    \definecolor{shadecolor}{rgb}{1,1,.65}
    \begin{shaded}{\color{red}TODO: #1}\end{shaded}
  \else
  \fi
}

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
\newcommand{\makefrontcover}{%
\thispagestyle{empty}
% Now using \usepackage[absolute]{textpos}. The positioning become a lot
% robuster this way wrt changes in margins etc.
%\begin{textblock}{160}(-17.5,-32.5)
\begin{textblock}{160}(0,0)
\vspace{-\parskip}
\begin{center}
\includegraphics[width=8mm]{image/sedes.eps}
\end{center}
\end{textblock}
%
%\begin{textblock}{100}(42.5,-12.5)
\begin{textblock}{100}(60,20)
\vspace{-\parskip}
\colorbox{gray}{\parbox[c][18mm]{98mm}{
{\bf \footnotesize \textcolor{white} {Arenberg Doctoral School of Science, Engineering \& Technology}}\\
{\footnotesize \textcolor{white} {\@faculty}}\\
{\footnotesize \textcolor{white} {\@department}}
}}
\end{textblock}
%
%\begin{textblock}{60}(-17.5,-12.5)
\begin{textblock}{60}(0, 20)
\textblockcolour{}
\vspace{-\parskip}
\includegraphics*[width=60mm]{image/kullogo2.eps}
\end{textblock}
%
%\begin{textblock}{120}(0,80)
\begin{textblock}{120}(17.5,112.5)
\textblockcolour{}
\vspace{-\parskip}
\Large\sffamily\textbf{\@title}
\end{textblock}
%
%\begin{textblock}{120}(0,92.5)
\begin{textblock}{120}(17.5,125)
\textblockcolour{}
\vspace{-\parskip}
\large\sffamily{\@subtitle}
\end{textblock}
%
%\begin{textblock}{120}(0,115)
\begin{textblock}{120}(17.5,147.5)
\textblockcolour{}
\vspace{-\parskip}
\large\sffamily\textbf{\@authorf\ \MakeUppercase\@authorl}
\end{textblock}
%
%\begin{textblock}{60}(82.5,160)
\begin{textblock}{60}(100,192.5)
\textblockcolour{}
\vspace{-\parskip}
Dissertation presented in partial\\
fulfillment of the requirements for\\
the degree of Doctor\\
in \@degree
\end{textblock}
%
%\begin{textblock}{160}(-17.5,185)
\begin{textblock}{160}(0,217.5)
\textblockcolour{}
\vspace{-\parskip}
\begin{center} \@date \end{center}
\end{textblock}

\newpage
\thispagestyle{empty} \mbox{}
\newpage

}

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
\begin{textblock}{120}(17.5,157.5)
\textblockcolour{}
\vspace{-\parskip}
\begin{minipage}[t]{7.32cm}
  \begin{tabular}[t]{p{7cm}}
    Jury:\\
    \@president, president\\
    \@promotor, promotor\\
    \@jury \\
    \@externaljurymember \\
    \rule{0.25cm}{0pt}(\@externalaffiliation)\\
    \\
    U.D.C. \@udc
  \end{tabular}
\end{minipage}
\begin{minipage}[t]{7cm}
  \begin{tabular}[t]{l}
    Dissertation presented in partial\\
    fulfillment of the requirements for\\
    the degree of Doctor \\
    in \@degree
  \end{tabular}
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
\@address, B-3001 Leuven (Belgium)}

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

\newcommand{\makebackcover}{%
%%% provide back cover
\cleardoublepage \mbox{}
\thispagestyle{empty}
\newpage
\thispagestyle{empty}
%
%\begin{textblock}{153}(-17.5,-12.5)
\begin{textblock}{153}(0,20)
\vspace{-\parskip}
\colorbox{gray}{\parbox[c][18.75mm]{151mm}{
\flushright
\vspace{-3mm}
{\bf \scriptsize \textcolor{white} {Arenberg Doctoral School of Science, Engineering \& Technology} \ \ }\\[-1mm]
{\tiny \textcolor{white} {\@faculty\ \ }}\\[-1mm]
{\tiny \textcolor{white} {\@department \ \ }}\\[-1mm]
{\tiny \textcolor{white} {\@researchgroup\ \ }}\\[-1mm]
{\tiny \textcolor{white} {\@address... \ \ }}
}}
\end{textblock}
%
%\begin{textblock}{7}(135.5,-12.5)
\begin{textblock}{7}(153,20)
\textblockcolour{}
\vspace{-\parskip}
\includegraphics*[angle=90,width=7mm]{image/kullogo2.eps}
\end{textblock}
%
%\begin{textblock}{12}[0.5,0.5](125,191)
\begin{textblock}{12}[0.5,0.5](142.5,223.5)
\textblockcolour{}
\vspace{-\parskip}
\includegraphics*[width=12mm]{image/ASSO_ZEGEL_ZW.ps}
\end{textblock}
}

\endinput
%%
%% End of file `adsphd.cls'.
