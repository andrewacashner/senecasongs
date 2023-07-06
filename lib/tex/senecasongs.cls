\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lib/tex/senecasongs}[2022/05/10 Seneca Songs book]

\LoadClass{book}
\RequirePackage{lib/tex/senecasongs}


\RequirePackage{sectsty}
\partfont{\titlingfont}
\chapterfont{\titlingfont}

\RenewDocumentCommand{\maketitle}{}{
    \begin{titlepage}
        \begin{center}
            \vspace*{1em}
            {\LARGE \MakeUppercase{\@aacMainTitle}}

            \vspace{2em}
            {\Large \@aacSubTitle}

            \vspace*{4em}
            {\large \@aacAuthor}

            \vspace{\fill}
            \includegraphics[width=\textwidth]{\@aacCoverImage}

            \vspace{\fill}
            {\large \@aacPublisher}
        \end{center}
    \end{titlepage}

    \clearpage
    \thispagestyle{empty}
    \vspace*{\fill}
    \begin{center}
        \@aacCopyright
    \end{center}
    \vspace*{\fill}
    \clearpage
}

\RequirePackage{fancyhdr}
\pagestyle{fancy}

\renewcommand{\chaptermark}[1]{%
    \markboth{\emph{#1}}{}%
}
\fancyhf{}
\fancyhead[LE]{\textsc{\@aacMainTitle}}
\fancyhead[RO]{\leftmark}
\fancyfoot[C]{\thepage}

\endinput


