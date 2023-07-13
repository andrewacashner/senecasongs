\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lib/tex/senecasongs}[2022/05/10 Seneca Songs book]

\LoadClass{book}
\RequirePackage{lib/tex/senecasongs}

\newif\ifdraft
\draftfalse

\RequirePackage{sectsty}
\partfont{\titlingfont}
\chapterfont{\titlingfont}

\RenewDocumentCommand{\maketitle}{}{
    \begin{titlepage}
        \begin{center}
            \vspace*{1em}
            {\titlingfont\Huge\MakeUppercase{\@aacMainTitle}}%\MakeUppercase{\@aacMainTitle}}

            \vspace{2em}
            {\Large\textbf{\@aacSubTitle}}

            \ifdraft
                \vspace{1em}
                {\huge DRAFT}\par
                \vspace{2em}
            \else
                \vspace*{4em}
            \fi
            {\large\@aacAuthor}
            

            \vspace{\fill}
            \includegraphics[width=\textwidth]{\@aacCoverImage}

            \vspace{\fill}
            {\begin{tabular}{c}
                \large\@aacLocation \\
                \large\@aacPublisher \\
                \large\addfontfeatures{Numbers=OldStyle}{\@aacYear}
            \end{tabular}}
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

\NewDocumentCommand{\CClicense}{}{%
    \par\vspace{2em}\begin{center}
    %\includegraphics[width=1in]{media/CC} \\
    This work is licensed under a \href{http://creativecommons.org/licenses/by-nc-nd/4.0/}{Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License}.
    \end{center}
}
% image: https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png

\RequirePackage{fancyhdr}
\pagestyle{fancy}

\renewcommand{\chaptermark}[1]{%
    \markboth{\emph{#1}}{}%
}
\fancyhf{}
\fancyhead[LE]{\textsc{\@aacMainTitle}}


\fancyhead[RE]{\ifdraft DRAFT\fi}
\fancyhead[LO]{\ifdraft DRAFT\fi}

\fancyhead[RO]{\leftmark}
\fancyfoot[C]{\thepage}

% Use empty pagestyle instead of plain -> result, no page numbers for part or
% chapter first pages
\fancypagestyle{plain}{\pagestyle{empty}}

\endinput


