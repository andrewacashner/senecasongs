\version "2.22"

%% just use -dcrop
% #(ly:set-option 'crop #t)

%% or just use default
\paper { 
    #(define fonts 
        (set-global-fonts #:roman "Crimson")) 
}

\header { 
    tagline = ##f
}

\layout {
    \context {
        \Staff
            \omit TimeSignature
            \omit StaffSymbol
            \omit Clef
            \omit BarLine
    }
}

