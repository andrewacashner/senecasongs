\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{neh}[2022/03/16 NEH application]
\LoadClass[11pt]{article}

\RequirePackage[T1]{fontenc}
\RequirePackage{newtxmath, newtxtext}
\RequirePackage[margin=1in]{geometry}

\RequirePackage{semantic-markup}
\RequirePackage{microtype}

\RequirePackage{sectsty}
\allsectionsfont{\normalfont\sffamily}
\RequirePackage{url}
\urlstyle{sf}

\RequirePackage{booktabs}


\RequirePackage[authordate]{biblatex-chicago}
\addbibresource{indigenous.bib}
\setlength{\bibitemsep}{0pt}

\RequirePackage{newunicodechar}
\newunicodechar{ħ}{$\mathrm{\hbar}$}
\setcounter{secnumdepth}{0}

\endinput
