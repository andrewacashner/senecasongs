\version "2.22"
\include "notes-in-text.ly"
% { g'8[ 8 8] 4 8 4 }
\score {
    \new Staff
    << 
    \new Voice { \voiceOne g'8 4 8 4 }
    \new Voice { \voiceTwo r8 d'4 8 4 }
    >>
}

