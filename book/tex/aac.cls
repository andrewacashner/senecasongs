\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tex/aac}[2022/05/10 Test class for TEI documents converted via
XSLT]

\LoadClass{book}
\RequirePackage[T1]{fontenc}
\RequirePackage{crimson}
\RequirePackage{microtype}

\RequirePackage{geometry}

\RequirePackage{semantic-markup}

\RequirePackage[authordate]{biblatex-chicago}
% \addbibresource{tex/main.bib}

\RequirePackage{hyperref}

\RequirePackage{graphicx}
\graphicspath{{media}}

\NewDocumentCommand{\displayTitle}{}{
    \vspace*{10em}
    \begin{center}
        \Huge
        \@title
    \end{center}
}

\NewDocumentCommand{\displayAuthor}{}{
    \vspace*{5em}
    \begin{center}
        \huge
        \@author
    \end{center}
    \addvspace{5em}
}

\endinput
