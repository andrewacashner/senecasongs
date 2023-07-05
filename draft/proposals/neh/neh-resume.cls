\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{neh-resume}[2022/03/18 resume for NEH application]

\LoadClass[11pt]{article}

\RequirePackage[T1]{fontenc}
\RequirePackage{newtxmath, newtxtext}
\RequirePackage{url}
\urlstyle{sf}
\RequirePackage{semantic-markup}

\RequirePackage[margin=1in]{geometry}
\setlength{\parindent}{0pt}
\RequirePackage{microtype}
\raggedright
\RequirePackage[none]{hyphenat}
\setcounter{secnumdepth}{0}

\RequirePackage{sectsty}
\allsectionsfont{\normalfont\sffamily}

\RequirePackage{tabularx}

\newlength{\datewd}
\AtBeginDocument{\settowidth{\datewd}{2017--Present}}

\NewDocumentCommand{\cvItem}{ m m o }{%
    \begin{tabularx}{\textwidth}{@{}p{\datewd} X@{}}
        #1 & #2
    \end{tabularx}%
    \IfValueTF{#3}{\par
        \smallskip\hspace{\dimexpr\datewd+2em}%
        \parbox{\dimexpr\textwidth-\datewd-2em}{#3}\par
        \smallskip}
        {\par}
}

\NewDocumentCommand{\cvName}{ m }{%
    \noindent{\huge #1\par
    \addvspace{0.5\baselineskip}}%
}

\NewDocumentEnvironment{cvAddress}{}
{\begin{tabular}{@{}l}}
{\end{tabular}}

\NewDocumentEnvironment{cvSkillTable}{}
{\tabularx{\textwidth}{@{}l X@{}}}
{\endtabularx}

\endinput
