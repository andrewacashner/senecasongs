\version "2.22"

%% just use -dcrop
% #(ly:set-option 'crop #t)

\include "font.ly"
\include "analysis-brackets.ly"

\header { 
    tagline = ##f
}

\layout {
    \context {
        \Staff
        \omit TimeSignature
        \omit BarLine
    }
}
