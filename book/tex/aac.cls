\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tex/aac}[2022/05/10 Test class for TEI documents converted via
XSLT]

\LoadClass{book}
\RequirePackage[T1]{fontenc}

\RequirePackage{venturis}
\RequirePackage{crimson}

\RequirePackage{sectsty}
\allsectionsfont{\sffamily}

\RequirePackage{microtype}

\RequirePackage[
    paperheight=8.5in, 
    paperwidth=5.5in,
    vmargin=1in
]{geometry}

\RequirePackage{semantic-markup}

\RequirePackage[authordate]{biblatex-chicago}
% \addbibresource{tex/main.bib}


\RequirePackage{graphicx}
\graphicspath{{media}}

\NewExpandableDocumentCommand{\@aacMainTitle}{}{}
\NewExpandableDocumentCommand{\@aacSubTitle}{}{}
\NewExpandableDocumentCommand{\@aacAuthor}{}{}
\NewExpandableDocumentCommand{\@aacPublisher}{}{}
\NewExpandableDocumentCommand{\@aacCopyright}{}{}
\NewExpandableDocumentCommand{\@aacCoverImage}{}{}

\NewDocumentCommand{\setMainTitle}{ m }{%
    \RenewExpandableDocumentCommand{\@aacMainTitle}{}{#1}%
}

\NewDocumentCommand{\setSubTitle}{ m }{%
    \RenewExpandableDocumentCommand{\@aacSubTitle}{}{#1}%
}

\NewDocumentCommand{\setAuthor}{ m }{%
    \RenewExpandableDocumentCommand{\@aacAuthor}{}{#1}%
}

\NewDocumentCommand{\setPublisher}{ m }{%
    \RenewExpandableDocumentCommand{\@aacPublisher}{}{#1}%
}

\NewDocumentCommand{\setCopyright}{ m }{%
    \RenewExpandableDocumentCommand{\@aacCopyright}{}{#1}%
}

\NewDocumentCommand{\setCoverImage}{ m }{%
    \RenewExpandableDocumentCommand{\@aacCoverImage}{}{#1}%
}

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
    \vspace*{\fill}
    \begin{center}
        \@aacCopyright
    \end{center}
    \vspace*{\fill}
    \clearpage
}

\RequirePackage[hidelinks]{hyperref}
\endinput
