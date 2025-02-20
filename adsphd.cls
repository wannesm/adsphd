%%
%% Copyright (C) 2009-2025 by KU Leuven
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
    [2024/12/16 v2.0 Standard KU Leuven Arenberg Doctoral School PhD class]

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
\setlength{\defaultlbleed}{0mm}
\newlength{\defaultrbleed}
\setlength{\defaultrbleed}{5mm}
\newlength{\defaulttbleed}
\setlength{\defaulttbleed}{0mm}
\newlength{\defaultbbleed}
\setlength{\defaultbbleed}{0mm}
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
\definecolor{kullightblue}{cmyk/RGB/rgb}{.59,.07,0,0/82,189,236/.322,.741,.925}
\definecolor{kulcorporateblue}{cmyk/RGB/rgb}{1,.64,0,.38/0,64,122/0,.251,.478}
\definecolor{kulprimaryblue}{cmyk/RGB/rgb}{.65,0,0,.35/29,141,176/.114,.553,.690}
\definecolor{kulsecondaryblue}{cmyk/RGB/rgb}{.13,0,0,.07/220,231,240/.863,.906,.941}
\definecolor{kultertiarylightblue}{cmyk/RGB/rgb}{.59,.07,0,0/82,189,236/.322,.741,.925}
\definecolor{kultertiaryblue}{cmyk/RGB/rgb}{.65,0,0,.55/70,110,135/.275,.431,.529}
\definecolor{kultertiarydarkblue}{cmyk/RGB/rgb}{.65,0,0,.75/47,77,93/.184,.302,.365}
\definecolor{kultertiaryaccent1}{cmyk/RGB/rgb}{.60,0,.30,0/135,192,189/.529,.753,.741}
\definecolor{kultertiaryaccent2}{cmyk/RGB/rgb}{0,.35,.90,0/231,176,55/.906,.690,.216}
\definecolor{kultertiaryaccent3}{cmyk/RGB/rgb}{.30,0,.70,.30/156,166,90/.612,.651,.353}
\definecolor{kultertiaryaccent4}{cmyk/RGB/rgb}{.14,.05,.90,0/228,218,62/.894,.855,.243}
\definecolor{kultertiaryaccent5}{cmyk/RGB/rgb}{.31,0,.12,.10/184,208,212/.722,.816,.831}
\definecolor{kultertiaryaccent6}{cmyk/RGB/rgb}{.34,.36,.59,.0/176,159,118/.690,.624,.463}
\definecolor{kultertiaryaccent7}{cmyk/RGB/rgb}{0,.65,.50,0/212,119,110/.831,.467,.431}
\definecolor{kultertiaryaccent8}{cmyk/RGB/rgb}{0,.10,1,.23/203,182,16/.796,.714,.063}
\definecolor{kultertiaryaccent9}{cmyk/RGB/rgb}{0,.51,.20,.30/170,121,130/.667,.475,.510}
\definecolor{kultertiaryaccent10}{cmyk/RGB/rgb}{.10,.50,.10,.05/199,147,174/.780,.576,.682}
\definecolor{kultertiaryaccent11}{cmyk/RGB/rgb}{.25,0,.90,0/212,216,66/.831,.847,.259}
\definecolor{kultertiaryaccent12}{cmyk/RGB/rgb}{.03,.60,.80,.15/186,113,60/.729,.443,.235}


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
\DeclareBoolOption{helveticaneue}
\DeclareBoolOption{joint}
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
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{helveticaneue}
  \DisableKeyvalOption[action=warning,package=adsphd]{adsphd}{joint}

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
      \message{Using: \gitdescribe}
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


% Allow for multiple presidents
\DTLnewdb{president}
\newcommand{\@president}[2]{%
  \DTLnewrow{president}%
  \DTLnewdbentry{president}{name}{#1}%
  \DTLnewdbentry{president}{affiliation}{#2}%
}
\newcommand{\@presidentfirst}[2]{%
  \DTLforeach{president}{}{\DTLremovecurrentrow}
  \let\president\@president
  \president{#1}{#2}
}
\let\president\@presidentfirst


% Allow for multiple jury members
\DTLnewdb{jury}
\newcommand{\@jurymember}[2]{%
  \DTLnewrow{jury}%
  \DTLnewdbentry{jury}{name}{#1}%
  \DTLnewdbentry{jury}{affiliation}{#2}%
}
\newcommand{\@jurymemberfirst}[2]{%
  \DTLforeach{jury}{}{\DTLremovecurrentrow}
  \let\jurymember\@jurymember
  \jurymember{#1}{#2}
}
\let\jurymember\@jurymemberfirst


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
\def\udc#1{\gdef\@udc{#1}}
\def\depot#1{\gdef\@depot{#1}}
\def\isbn#1{\gdef\@isbn{#1}}
\def\rev#1{\gdef\@rev{#1}}
\gdef\@rev{}

\def\copyyear#1{\gdef\@copyyear{#1}}
\def\copyaddress#1{\gdef\@copyaddress{#1}}
\def\researchgroup#1{\gdef\@researchgroup{#1}}
\def\address#1{\gdef\@address{#1}}
\def\addresscity#1{\gdef\@addresspc{#1}}
\def\email#1{\gdef\@email{#1}}
\def\website#1{\gdef\@website{#1}}
\def\facultypartner#1{\gdef\@facultypartner{#1}}
\def\departmentpartner#1{\gdef\@departmentpartner{#1}}
\def\researchgrouppartner#1{\gdef\@researchgrouppartner{#1}}
\def\addresspartner#1{\gdef\@addresspartner{#1}}
\def\addresscitypartner#1{\gdef\@addresspcpartner{#1}}
\def\emailpartner#1{\gdef\@emailpartner{#1}}
\def\websitepartner#1{\gdef\@websitepartner{#1}}

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
\@supervisor{Prof.~dr.~ir.~Supervisor}{}
\@president{Prof.~dr.~ir.~The~Chairman}{}
\@jurymember{Prof.~dr.~ir.~The~One}{}
\@jurymember{Prof.~dr.~ir.~The~Other}{}
\@externaljurymember{Prof.~dr.~External~Jurymember}{Far Away}
\udc{}
\depot{}
\isbn{}

\researchgroup{Research group ...}
\address{Address ...}
\addresscity{B-3001 Leuven}
\title{Dissertation title ...}
\subtitle{}
\date{Month Year}
\copyyear{2024}
\copyaddress{Leuven}
\email{first.name@dept.kuleuven.be}
\website{www.website.kuleuven.be}

\researchgrouppartner{Research group partner...}
\addresspartner{Address partner}
\addresscitypartner{City partner}
\emailpartner{first.name@partner.com}
\websitepartner{www.partner.com}


% Default filename for custom cover page
\newcommand{\@customcoverpage}{mycoverpage.tex}

% Default title of chapter containing preface, abstract, publications,
% cv, ...  Note that the values below are merely suggestions. In
% practice only the string given in the \chapter{.} command in the
% included tex file will be used!
\newcommand{\prefname}{Preface}
\newcommand{\prefnlname}{Dankwoord}
\newcommand{\popabstname}{Popularized Abstract}
\newcommand{\popabstnlname}{Gepopulariseerde Samenvatting}
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
\TPMargin{0.0001mm}
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
    % \ifshellescape
      %\cropdef[\cropgitinfo]\CROP@@frame\relax\relax\relax{gitinfo}
      %\crop[gitinfo]
      \let\orig@CROP@time=\CROP@time
      \renewcommand{\CROP@time}{\orig@CROP@time\x\gitdescribe}
    % \fi
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
\ifadsphd@helveticaneue
\typeout{adsphd: Using Helvetica Neue, make sure to compile via
LuaLaTeX or XeTeX}
\RequirePackage{fontspec}
\let\origsfdefault\sfdefault
\newfontfamily\hnlcoverfont{HelveticaNeueLight}[BoldFont=HelveticaNeueMedium]
\newfontfamily\hncoverfont{HelveticaNeue}[BoldFont=HelveticaNeueBold]
\newcommand{\coverfont}{\hnlcoverfont}
\newcommand{\coverfontlight}{\hnlcoverfont}
\newcommand{\titlepagefont}{\sffamily}
% Change font everywhere
% \setsansfont[BoldFont=HelveticaNeue]{HelveticaNeueLight}
\else
\let\origsfdefault\sfdefault
\RequirePackage[scaled]{helvet}
\let\helvetsfdefault\sfdefault
\renewcommand{\sfdefault}{\origsfdefault}
\newcommand{\coverfont}{\sffamily}
\newcommand{\coverfontlight}{\sffamily}
\newcommand{\titlepagefont}{\sffamily}
\fi

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

\newcommand{\includepopabstract}[1]{%
  \IncludeUnnumberedChapterIfExists{#1}{\popabstname}{\instructionspopabstract}
        {\phantomsection}
}

\newcommand{\includepopabstractnl}[1]{%
  \selectlanguage{dutch}
  \IncludeUnnumberedChapterIfExists{#1}{\popabstnlname}{\instructionspopabstract}
        {\phantomsection}
  \ifadsphd@british
  \selectlanguage{british}
  \else
  \selectlanguage{english}
  \fi
}

\newcommand{\includeabstract}[1]{%
  \IncludeUnnumberedChapterIfExists{#1}{\abstname}{\instructionsabstract}
        {\phantomsection}
}

\newcommand{\includeabstractnl}[1]{%
  \selectlanguage{dutch}
  \IncludeUnnumberedChapterIfExists{#1}{\abstnlname}{\instructionsabstract}
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
  \microtypesetup{protrusion=false}
  \listoffiguresorig
  \microtypesetup{protrusion=true}
}

\let\listoftablesorig\listoftables
\renewcommand{\listoftables}{%
  \cleardoublepage
  \phantomsection
  \addcontentsline{toc}{chapter}{\lotname}
  \microtypesetup{protrusion=false}
  \listoftablesorig
  \microtypesetup{protrusion=true}
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

\newcommand{\includegenai}{%
\chapter*{Statement on the use of Generative AI}
  \instructionsgenai
  \ifthenelse{\equal{\theUseOfGenAI}{}}{}{%
    \theUseOfGenAI\\
  }
  The text, code, and images in this thesis are my own (unless otherwise specified). Generative AI has
  only been used in accordance with the KU~Leuven guidelines and appropriate references have been added.
  I have reviewed and edited the content as needed and I take full responsibility for the content of
  the thesis.
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
  \textbf{Instructions by the Arenberg Doctoral School:} 
  
  }%
  {
    \end{shaded}
}

\newcommand{\instructionspreface}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
Preface- Acknowledgements:
The preface should summarise the general aim of the work. People,
offices, companies and agencies who have awarded a doctoral
scholarship (e.g., FWO, VLAIO, EC) should be thanked for their support.
However, the names of these people, offices, companies and agencies
may only be mentioned with their explicit consent and after
consultation with the supervisor.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionspopabstract}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
The popularized abstract should be approximately 1 page long with
contents and language that's suited to a wider circle of readers (not
experts in your field). It should be easy to understand and enjoyable
to read. Look at it as an advertisement for your PhD project. 
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsabstract}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
The scientific abstract should present the most important aims and
conclusions of the dissertation in a brief text of ca. 2 pages.
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
List of abbreviations and list of symbols:
These are lists of the most important abbreviations and symbols used
in the work, mentioning indices, meaning and measures used.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionstableofcontents}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
Table of contents: 
The table of contents should be arranged neatly and must refer to the
pages of the different sections (maximum three levels). Preceding
chapter one, Roman numerals (I, II, \ldots) should be used for the page
numbering. From chapter one onwards, Western Arabic numerals (1, 2,
\ldots) should be used.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsintroduction}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
An in-depth introduction outlining the research in a broader context:
Starting from a description of the state of the art in the domain,
additionally, the research questions and objectives  are formulated.
Furthermore, this includes the global approach and research methods.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionschapters}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
Report and discussion of the research in different chapters:   These
chapters, reporting and discussing research results, can be based on
text that has already been published or accepted or submitted to
journals or conferences. In that case, the bibliographic reference of
the publication should be mentioned on the first page of the chapter.
If there are multiple authors, the PhD researcher must clarify the own
scientific contribution after that bibliographic reference on the
first page of the chapter. There is no problem in editing or rewriting
a text that has already been published or accepted for publication,
for example to reach consistency and coherence in writing style and
formatting, to add details that were left out from publication, to
meet comments of the Examination Committee, etc;
The doctoral candidate must determine whether the publisher allows
public availability of the publications and in which form via the
webpage Romeo/Sherpa.

Consistency in layout is required for the entire manuscript!
References to figures, tables, appendices, and similar structures need
to be consistent.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsconclusions}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
An extensive conclusion, including a global discussion of the
research results, a discussion of the implications of the PhD research
and future perspectives in regards to follow-up research.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsbibliography}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
Bibliography:
Should be arranged according to the guidelines generally accepted in
the relevant research domain.

The thesis needs to be consistent in relation to bibliographic and
other references. Either a global list of bibliographic references is
provided at the end of the thesis, or each chapter contains
bibliographic references at the end, but there cannot be a combination
of these two methods of referencing.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionslistofpublications}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
List of scientific publications with a clear DOI (digital object
identifier) number mentioned:(optional): The list of scientific
publications by the doctoral researcher should be arranged according
to the guidelines generally accepted in the relevant research domain.
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionscv}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
Curriculum vitae: Short CV of the PhD candidate.
\end{ftw_instructions}
  \else
  \fi
}
\newcommand{\instructionsgenai}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
Read the guidelines in relation to GenAI at KU Leuven and add the `statement
on the use of Generative AI' in your manuscript.

\ifthenelse{\equal{\theUseOfGenAI}{}}{%
  Uncomment the appropriate sentences in the \textbackslash useOfGenAI command
  and expand the text where needed to make it more specific and add topics if they are not covered
  by any of the indicated topics.
}{}
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\instructionsappendices}{
  \ifadsphd@showinstructions
\begin{ftw_instructions}
Appendices: The appendices should include parts of the research
which are essential for the work, but which may hamper the readability
of the text, e.g. because of their length (mathematical deductions,
experimental data, examples, figures, etc.).
\end{ftw_instructions}
  \else
  \fi
}

\newcommand{\theUseOfGenAI}{}
\newcommand{\useOfGenAI}[1]{\renewcommand{\theUseOfGenAI}{#1}}


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
% Define front and back cover
%
% For guidelines:
% https://set.kuleuven.be/phd/researchers/template_kaft/guidelines_PhDthesis.htm

\newcommand{\cropline}[4]{%
  \setlength{\unitlength}{1mm}
  \linethickness{.5pt}
  \setlength{\tmplength}{2mm}
  \setlength{\tmplength}{#3\tmplength}
  % \typeout{the tmplenght \the\tmplength}
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

\newcommand{\croplineh}[4]{%
  \setlength{\unitlength}{1mm}
  \linethickness{.5pt}
  \setlength{\tmplength}{2mm}
  \setlength{\tmplength}{#3\tmplength}
  % \typeout{the tmplenght \the\tmplength}
  \begin{textblock*}{0mm}(#1+\tmplength,#2)%
  \ifthenelse{\equal{#3}{1}}{
    \begin{picture}(#4,1)(0,-1)
      \put(0,0){\line(1,0){#4}}
    \end{picture}
  }{ % #3 == -1
    \begin{picture}(-#4,1)(0,-1)
      \put(0,0){\line(-1,0){#4}}
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
    \let\makefrontcovergeneral\orig@makefrontcovergeneral
    \let\makebackcovergeneral\orig@makebackcovergeneral
  }
}{}

\newcommand{\makefullcoverpage}[2]{%
  \typeout{Making full cover page}
  % #1: spinewidth
  % #2: spinetitlewidth
  \setlength{\lbleed}{\defaultlbleed}
  \setlength{\rbleed}{\defaultrbleed}
  \setlength{\tbleed}{\defaulttbleed}
  \setlength{\bbleed}{\defaultbbleed}
  \setlength{\adsphdspinewidth}{#1}

  \newlength{\skiplen}

  %\begin{textblock*}{\adsphdspinewidth+4pt}(\lbleed+\rbleed+\adsphdpaperwidth-2pt, 20mm)
  %\textblockcolour{}
  %\includegraphics[width=\adsphdspinewidth+4pt,height=20mm]{image/blue}
  %\end{textblock*}

  \setlength{\skiplen}{0mm+\rbleed}
  \makebackcovergeneralXXIV{\skiplen}{0}

  \setlength{\skiplen}{\lbleed+\rbleed+\adsphdpaperwidth}
  \makespinegeneralXXIV{\skiplen}{0}{#1}{#2}

  \setlength{\skiplen}{\rbleed+2\lbleed+\adsphdpaperwidth+\adsphdspinewidth}
  \makefrontcovergeneralXXIV{\skiplen}{0}

  \drawextracroplines
}

\newcommand{\drawextracroplines}{%
  % Draw some extra crop lines
  % Croplines on top
  \cropline{\rbleed}{0mm}{-1}{5}
  \cropline{\rbleed+\adsphdpaperwidth}{0mm}{-1}{5}
  \cropline{\rbleed+\lbleed+\adsphdpaperwidth}{0mm}{-1}{10}
  \cropline{\rbleed+\lbleed+\adsphdpaperwidth+\adsphdspinewidth}{0mm}{-1}{10}
  \cropline{\rbleed+2\lbleed+\adsphdpaperwidth+\adsphdspinewidth}{0mm}{-1}{5}
  \cropline{\rbleed+2\lbleed+2\adsphdpaperwidth+\adsphdspinewidth}{0mm}{-1}{5}
  % Croplines on bottom
  \cropline{\rbleed}{\adsphdpaperheight+\defaulttbleed+\defaultbbleed}{1}{5}
  \cropline{\rbleed+\adsphdpaperwidth}{\adsphdpaperheight+\defaulttbleed+\defaultbbleed}{1}{5}
  \cropline{\rbleed+\lbleed+\adsphdpaperwidth}{\adsphdpaperheight+\defaulttbleed+\defaultbbleed}{1}{10}
  \cropline{\rbleed+\lbleed+\adsphdpaperwidth+\adsphdspinewidth}{\adsphdpaperheight+\defaulttbleed+\defaultbbleed}{1}{10}
  \cropline{\rbleed+2\lbleed+\adsphdpaperwidth+\adsphdspinewidth}{\adsphdpaperheight+\defaulttbleed+\defaultbbleed}{1}{5}
  \cropline{\rbleed+2\lbleed+2\adsphdpaperwidth+\adsphdspinewidth}{\adsphdpaperheight+\defaulttbleed+\defaultbbleed}{1}{5}
  % Croplines on left
  \croplineh{0mm}{\tbleed}{-1}{5}
  \croplineh{0mm}{\tbleed+\adsphdpaperheight}{-1}{5}
  % Croplines on right
  \croplineh{2\rbleed+2\lbleed+2\adsphdpaperwidth+\adsphdspinewidth}{\tbleed}{1}{5}
  \croplineh{2\rbleed+2\lbleed+2\adsphdpaperwidth+\adsphdspinewidth}{\tbleed+\adsphdpaperheight}{1}{5}

}

\newcommand{\drawextracroplinesexplanation}{%
  \@ifpackageloaded{tikz}{%
  \begin{textblock*}{2cm}(\rbleed+2\lbleed+2\adsphdpaperwidth+\adsphdspinewidth-2cm,0mm)
    \textblockcolour{}%
    \resizebox{2cm}{!}{%
    \begin{tikzpicture}
      \draw[->] (0,0) to[bend right] (0.5,1);
      \node[anchor=east] at (0,0) {cropmark(R)};
    \end{tikzpicture}%
    }%
  \end{textblock*}
  \begin{textblock*}{4cm}(\rbleed+2\lbleed+\adsphdpaperwidth+\adsphdspinewidth,0mm)
    \textblockcolour{}%
    \resizebox{4cm}{!}{%
    \begin{tikzpicture}
      \draw[->] (0.5,0) to[bend left] (0,1);
      \node[anchor=west] at (0.5,0) {cropmark(L) / spine fold line};
    \end{tikzpicture}%
    }%
  \end{textblock*}
  }{%
    \typeout{Tikz not found}
  }
}

\let\makefrontcover\makefrontcoverXXIV
\let\makebackcover\makebackcoverXXIV

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Provide front cover using the 2024 (XXIV) layout
% used by the Arenberg Doctoral School
%
% Huisstijl is followed with:
% Logo: X=20mm, Y=56mm
% X/2=10mm, a=2mm, b=6m
% Pagesize: Publicaties >=A5 <A3
% Bar on top: X/2+a+b = 18mm
% Logo wrt side: X/2 = 10mm
% Text wrt side: X/2+b = 16mm
% Text wrt bottom: X/2+b = 16mm
\newcommand{\frontcoverheaderXXIV}[1]{%
  \thispagestyle{empty}
  % Blue bar on top
  \begin{textblock*}{\adsphdpaperwidth+\lbleed+\rbleed}(0mm-\lbleed+#1,18mm+\tbleed)
  \textblockcolour{kulprimaryblue}
  %\vspace{-\parskip}
  \rule{0pt}{34mm}
  \end{textblock*}
  %
  % Create logo box
  \begin{textblock*}{56mm}(10mm+#1,10mm+\tbleed)
  % explicitly turn off block colour to prevent the coloured background from popping up due to misalignment of the logo
  \textblockcolour{}
  \includegraphics[width=56mm,height=20mm]{image/KULEUVEN_LOGO_2012}
  \end{textblock*}
  %
  % Create ADS+faculty box
  \begin{textblock*}{85mm}(16mm+#1,35mm+\tbleed)
  \textblockcolour{}
  \coverfont
  \raggedright
  \fontsize{10}{11}\selectfont%
  \def\tmphss{hss}%
  \ifx\tmphss\adsphd@doctoralschool
  \typeout{adsphd: Cover, smaller font size to fit doctoral school name}
  \fontsize{10}{11}\selectfont%
  \fi
  {\textcolor{white} 
  {\textbf{\expandafter\MakeUppercase\expandafter\@doctoralschool}\\[.2mm]
   \@faculty}}
  \end{textblock*}
}

\newcommand{\frontcoverheaderXXIVjoint}[1]{%
  \thispagestyle{empty}
  % Use Helvetica
  \ifadsphd@helveticaneue
  \else
  \renewcommand{\sfdefault}{\helvetsfdefault}
  \fi
  % Blue bar on top
  \begin{textblock*}{\adsphdpaperwidth+\lbleed+\rbleed}(0mm-\lbleed+#1,0mm)
  \textblockcolour{kulprimaryblue}
  %\vspace{-\parskip}
  \rule{0pt}{18mm+\tbleed}
  \end{textblock*}
  %
  % Blue bar below logos
  \begin{textblock*}{\adsphdpaperwidth+\lbleed+\rbleed}(0mm-\lbleed+#1,38mm+\tbleed)
  \textblockcolour{kulprimaryblue}
  %\vspace{-\parskip}
  \rule{0pt}{18mm}
  \end{textblock*}
  %
  % Create logo box KU Leuven
  \begin{textblock*}{34mm}(16mm+#1,21mm+\tbleed)
  % explicitly turn off block colour to prevent the coloured background from popping up due to misalignment of the logo
  \textblockcolour{}
  \includegraphics[width=34mm,height=12mm]{image/KULEUVEN_LOGO_2012}
  \end{textblock*}
  %
  % Create logo box partner university
  \begin{textblock*}{34mm}(\adsphdpaperwidth+#1-34mm-16mm,21mm+\tbleed)
  % explicitly turn off block colour to prevent the coloured background from popping up due to misalignment of the logo
  \textblockcolour{}
  \includegraphics[width=34mm,height=12mm]{image/PARTNER_LOGO}
  \end{textblock*}
  %
  % Create ADS + faculty box KU Leuven
  \begin{textblock*}{85mm}(16mm+#1,43mm+\tbleed)
  \textblockcolour{}
  \coverfont
  \raggedright
  \fontsize{10}{11}\selectfont%
  \def\tmphss{hss}%
  \ifx\tmphss\adsphd@doctoralschool
  \typeout{adsphd: Cover, smaller font size to fit doctoral school name}
  \fontsize{10}{11}\selectfont%
  \fi
  {\textcolor{white} 
  {\textbf{\expandafter\MakeUppercase\expandafter\@doctoralschool}\\[.2mm]
   \@faculty}}
  \end{textblock*}
}

\newcommand{\frontcoverfooterXXIV}[1]{%
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

\newcommand{\makefrontcoverXXIV}{\makefrontcovergeneralXXIV{0mm}{1}}
\ifadsphd@epub
  % The cover uses absolute positioning and does not scale automatically
  % to smaller page sizes, thus leave out
  \renewcommand{\makefrontcoverXXIV}{}
\fi
\newcommand{\makefrontcovergeneralXXIV}[2]{%
  \typeout{adsphd.cls: Create cover using bleed = (\the\rbleed,\the\lbleed,\the\tbleed,\the\bbleed)}
  % Use Helvetica
  \ifadsphd@helveticaneue
  \coverfont
  \else
  \renewcommand{\sfdefault}{\helvetsfdefault}
  \fi
  %
  % Create header
  \ifadsphd@joint
  \frontcoverheaderXXIVjoint{#1}
  \else
  \frontcoverheaderXXIV{#1}
  \fi
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
  % Put a DRAFT notifier on the front page to avoid printing a wrong version
  \ifadsphd@final\else
    \begin{textblock*}{120mm}(17.5mm+#1,120mm+\tbleed)
    \textblockcolour{}
    \vspace{-\parskip}
    \begin{center}
        \selectfont\LARGE\coverfont\textbf{\color{red}{
            DRAFT\\
            {\small To remove, add `final' to class options}
        }}
    \end{center}
    \end{textblock*}
  \fi
  %
  % Place the title and subtitle
  \begin{textblock*}{135mm}(16mm+#1,77mm+\tbleed)
  \textblockcolour{}
  \vspace{-\parskip}
  \raggedright
  \coverfontsize{32}{38}\selectfont\coverfontlight{\color{kulprimaryblue}\@title}\\[1ex]
  \coverfontsize{20}{25}\selectfont\coverfontlight{\@subtitle}
  \end{textblock*}
  %
  \begin{textblock*}{160mm}(16mm+#1,174mm+\tbleed)  % {hsize}(hpos,vpos)
    \textblockcolour{}%
    \setlength{\fboxsep}{0pt}%
    {%
    \begin{minipage}[b][50mm][b]{60mm}
      \fontsize{9}{11}\selectfont\coverfontlight
      \ifadsphd@covershowcommittee
        % NOT SUPPORTED
        \typeout{ERROR: Show full committee on front page not supported}
      \fi
      \dtlifnumlt{\DTLrowcount{supervisor}}{2}{Supervisor:}{Supervisors:}
      \DTLforeach{supervisor}{\name=name,\affiliation=affiliation}{%
        \\\name
        \ifthenelse{\equal{\affiliation}{}}{}{%
          \\\rule{0.25cm}{0pt}(\affiliation)
      }}
      % Deprecated: Everybody is supervisor
      %\DTLforeach{cosupervisor}{\name=name,\affiliation=affiliation}{%
      %\\\name%, co-supervisor
      %\ifthenelse{\equal{\affiliation}{}}{}{%
      %\\\rule{0.25cm}{0pt}(\affiliation)
      %}}
      \if\empty\@udc \else \\U.D.C. \@udc\fi
    \end{minipage}
    }
  {%
    \begin{minipage}[b][50mm][b]{60mm}
      \textblockcolour{}
      \begin{flushright}
        {\fontsize{12}{14}\selectfont\coverfontlight\textbf{\@authorf\
        \@authorl}}
        \\[1em]
        {\fontsize{9}{11}\selectfont\coverfontlight%
          Dissertation presented in partial \fulfillment\\%
          of the requirements for the degree of\\%
          \@phddegree
        }
        \\[1em]
        {\fontsize{9}{11}\selectfont\coverfontlight\@date}
      \end{flushright}
    \end{minipage}
  }
  \end{textblock*}
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  %
  % Add footer
  \frontcoverfooterXXIV{#2}
}

\let\orig@makefrontcovergeneralXXIV\makefrontcovergeneralXXIV



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redefine title page
\renewcommand{\maketitle}{%
\cleardoublepage
\thispagestyle{empty} \mbox{}

\titlepageXXIV

% NEW PAGE
%\pagenumbering{roman}
\newpage
\thispagestyle{empty}
\mbox{}
\vfill
{\scriptsize\sffamily{\setlength{\parindent}{0ex}\copyright{}~\@copyyear~\@authorf~\@authorl \\
Uitgegeven in eigen beheer, \@authorf~\@authorl, \@copyaddress{} (Belgium)}

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


\newcommand{\titlepageXXIV}{%
%
% Title block
\begin{textblock}{120}(16,70)  % {hsize}(hpos,vpos)
\textblockcolour{}
\vspace{-\parskip}
\begin{flushleft}
  \coverfontsize{20}{22}\titlepagefont\textbf{\MakeUppercase\@title}\\[1ex]
  \coverfontsize{14}{16}\titlepagefont{\MakeUppercase\@subtitle}
\end{flushleft}
\end{textblock}
%
% Author block
\begin{textblock}{120}(16,105)
  \textblockcolour{}
  \vspace{-\parskip}
  \fontsize{12}{14}\titlepagefont{\@authorf\ \MakeUppercase\@authorl}
\end{textblock}
%
% Committee block
\begin{textblock}{160}(16,125)
  \textblockcolour{}
  \vspace{-\parskip}
  \begin{minipage}[b][60mm][b]{7.32cm}
    \fontsize{10}{11}\selectfont\titlepagefont
    \dtlifnumlt{\DTLrowcount{supervisor}}{2}{Supervisor:}{Supervisors:}
    \DTLforeach{supervisor}{\name=name,\affiliation=affiliation}{%
    \\\name
    \ifthenelse{\equal{\affiliation}{}}{}{%
      \\\rule{0.25cm}{0pt}(\affiliation)
    }}
    \\[1em]
    Members of the\\
    Examination Committee:
    \DTLforeach{president}{\name=name,\affiliation=affiliation}{%
    \\\name, chair
    \ifthenelse{\equal{\affiliation}{}}{}{%
      \\\rule{0.5cm}{0pt}(\affiliation)
    }}
    \DTLforeach{jury}{\name=name,\affiliation=affiliation}{%
    \\\name
    \ifthenelse{\equal{\affiliation}{}}{}{%
      \rule{0.5cm}{0pt}(\affiliation)
    }}
    \DTLforeach{externaljury}{\name=name,\affiliation=affiliation}{%
    \\\name
    \\\rule{0.25cm}{0pt}(\affiliation)
    }
    \if\empty\@udc \else \\U.D.C. \@udc\fi
  \end{minipage}
  \begin{minipage}[b][60mm][b]{5.3cm}
    \fontsize{10}{11}\selectfont\titlepagefont
    Dissertation presented in partial
    \fulfillment\ of the requirements for
    the degree of \@phddegree
  \end{minipage}
\end{textblock}
%
% Date block
\begin{textblock}{160}(0,210.0)
  \textblockcolour{}
  \fontsize{10}{11}\selectfont\titlepagefont
  \vspace{-\parskip}
  \begin{center} \@date \end{center}
\end{textblock}
} % End of \titlepageXXIV



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Provide back cover using the 2024 (XXIV) layout
% used by the Arenberg Doctoral School
\newcommand{\makebackcoverXXIV}{
    \ifadsphd@joint
    \makebackcovergeneralXXIVjoint{0mm}{1}
    \else
    \makebackcovergeneralXXIV{0mm}{1}
    \fi
}
\ifadsphd@epub
  \renewcommand{\makebackcoverXXIV}{}
\fi
\newcommand{\makebackcovergeneralXXIV}[2]{%
  \typeout{adsphd.cls: Using default back cover page}
  %
  % Use Helvetica
  \ifadsphd@helveticaneue
  \else
  \renewcommand{\sfdefault}{\helvetsfdefault}
  \fi
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
  % Background colored block
  \begin{textblock*}{\adsphdpaperwidth+\lbleed+\rbleed}(#1-\rbleed,18mm+\tbleed)
  %\begin{textblock*}{\adsphdpaperwidth}(0mm+#1,234mm)
  \textblockcolour{kulprimaryblue}
  %\vspace{-\parskip}
  \rule{0pt}{34mm}
  \end{textblock*}
  %
  % Text box with address
  \begin{textblock*}{124.5mm}(#1,24.5mm+\tbleed)
  \textblockcolour{}
  \vspace{-\parskip}
  %\parbox[c][20mm]{151.2mm+\rbleed}{
  \begin{flushright}
    \fontsize{7}{10}\coverfont\color{white}
    \MakeUppercase\@faculty\\[-1mm]
    \MakeUppercase\@department\\[-1mm]
    % \ifdefempty{\@researchgroup}{}{{\MakeUppercase\@researchgroup}}\\[-1mm]
    {\@address}\\[-1mm]
    {\@addresspc}\\[-1mm]
    \ifdefempty{\@email}{}{\@email}\\[-1mm]
    \ifdefempty{\@website}{}{\@website}
  \end{flushright}
  %}
  \end{textblock*}
  %
  % Blue vertical line
  \begin{textblock*}{1.5mm}(#1+129mm,27.5mm+\tbleed)
  \textblockcolour{kullightblue}
  %\vspace{-\parskip}
  \rule{0pt}{15mm}
  \end{textblock*}
  %
  % Put KULeuven sedes on top
  \begin{textblock*}{7mm}(135mm+#1,26.9mm+\tbleed)
  \textblockcolour{}
  \vspace{-\parskip}
  \includegraphics*[height=16.3mm]{image/sedes.png}%
  \end{textblock*}
}

\let\orig@makebackcovergeneralXXIV\makebackcovergeneralXXIV

\newcommand{\makebackcovergeneralXXIVjoint}[2]{%
  \typeout{adsphd.cls: Using default back cover page}
  %
  % Use Helvetica
  \ifadsphd@helveticaneue
  \else
  \renewcommand{\sfdefault}{\helvetsfdefault}
  \fi
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
  % Blue bar on top
  \begin{textblock*}{\adsphdpaperwidth+\lbleed+\rbleed}(#1-\rbleed,0mm)
  \textblockcolour{kulprimaryblue}
  \rule{0mm}{18mm+\tbleed}
  \end{textblock*}
  %
  % Blue bar below logos
  \begin{textblock*}{\adsphdpaperwidth+\lbleed+\rbleed}(#1-\rbleed,38mm+\tbleed)
  \textblockcolour{kulprimaryblue}
  \rule{0mm}{18mm}
  \end{textblock*}
  %
  % Text box with address KU Leuven
  \begin{textblock*}{\adsphdpaperwidth+\lbleed+\rbleed}(#1-16mm, 21mm+\tbleed)
  \textblockcolour{}
    \fontsize{7}{10}\coverfont
    \raggedleft
    \MakeUppercase\@faculty\\[-1mm]
    \MakeUppercase\@department\\[-1mm]
    {\@address}\\[-1mm]
    {\@addresspc}\\[-1mm]
    \ifdefempty{\@email}{}{\@email\\[-1mm]}
    \ifdefempty{\@website}{}{\@website\\[-1mm]}
  \end{textblock*}
  % 
  % Text box with address partner university
  \begin{textblock*}{100mm}(#1+16mm, 21mm+\tbleed)
  \textblockcolour{}
    \fontsize{7}{10}\coverfont
    \MakeUppercase\@facultypartner\\[-1mm]
    \MakeUppercase\@departmentpartner\\[-1mm]
    {\@addresspartner}\\[-1mm]
    {\@addresspcpartner}\\[-1mm]
    \ifdefempty{\@emailpartner}{}{\@emailpartner\\[-1mm]}
    \ifdefempty{\@websitepartner}{}{\@websitepartner\\[-1mm]}
  \end{textblock*}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the spine of the booklet
\newlength{\defaultspinetitlewidth}
\setlength{\defaultspinetitlewidth}{90mm}

\newlength{\spinetitlewidth}
\setlength{\spinetitlewidth}{\defaultspinetitlewidth}

%\newcommand{\makespine}[2]{\makespinegeneralXXIV{xskip}{clearpage}{spinewidth}{spinetitlewidth}}
\newcommand{\makespine}[2]{\makespinegeneralXXIV{0mm}{1}{#1}{#2}}

\newcommand{\makespinegeneralXXIV}[4]{%
  % Use Helvetica
  \ifadsphd@helveticaneue
  \else
  \renewcommand{\sfdefault}{\helvetsfdefault}
  \fi
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
  \settowidth{\authorlen}{\fontsize{9}{11}\coverfont\@authorf\ \@authorl}
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
  \begin{textblock*}{\adsphdspinewidth}(0mm+#1,18mm-\authorlenpenalty+\tbleed) % 9mm whitespace 
                                        % between blue and first letter of the author name
                                        % (possibly less because the author name might be
                                        % reallyreally long)
  \textblockcolour{}
  % Rotate the text
  \begin{turn}{-90}
  \makebox[\adsphdpaperheight-34mm+\authorlenpenalty][c]{% 20mm(white)+20mm(blue)+9mm(space before name)+7mm(after date)
  %
  % Place author
  \parbox[c][\adsphdspinewidth]{(\authorlen)}{
  \fontsize{9}{11}\coverfont\@authorf\ \@authorl%
  }
  \hfill
  %
  % Place title
  \parbox[c][\adsphdspinewidth]{\spinetitlewidth}{
    \centering
    \setstretch{.85}
    \fontsize{9}{11}\coverfont{\@title}
  }
  %
  % Place date
  \hfill\fontsize{9}{11}\coverfont\@date
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

