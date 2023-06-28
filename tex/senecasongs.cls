\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tex/senecasongs}[2022/05/10 Seneca Songs book]

\LoadClass{book}
\RequirePackage{tex/senecasongs}

\RequirePackage{sectsty}
\partfont{\titlingfont}
\chapterfont{\titlingfont}

\RenewDocumentCommand{\maketitle}{}{
    \begin{titlepage}
        \begin{center}
            \vspace*{1em}
            {\huge \MakeUppercase{\@aacMainTitle}}

            \vspace{2em}
            {\huge \emph{\@aacSubTitle}}

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

\endinput


