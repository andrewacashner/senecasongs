\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{neh}[2022/03/16 NEH application]
\LoadClass[11pt]{article}

\RequirePackage[T1]{fontenc}
\RequirePackage{newtxmath, newtxtext}
\RequirePackage[margin=1in]{geometry}

\RequirePackage{semantic-markup}
\RequirePackage{microtype}
\RequirePackage{url}
\urlstyle{sf}

\RequirePackage{sectsty}
\allsectionsfont{\normalfont\sffamily}
\setcounter{secnumdepth}{0}

\RequirePackage{booktabs}
\RequirePackage{tabularx}

\RequirePackage[authordate]{biblatex-chicago}
\addbibresource{indigenous.bib}
\setlength{\bibitemsep}{0pt}

\RequirePackage{newunicodechar}
\newunicodechar{ħ}{$\mathrm{\hbar}$}

\RequirePackage{graphicx}
\graphicspath{{include/}}
\NewDocumentCommand{\cvGraphicsBox}{ O{0.9\textheight} m }{%
    \fbox{\includegraphics[height=#1]{#2}}%
}

\RequirePackage{pdfpages}
\NewDocumentCommand{\cvIncludePDF}{ O{pages={1-}} m }{%
    \includepdf[#1]{#2}%
}

\endinput
