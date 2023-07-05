\version "2.22"
\include "notes-in-text.ly"
% { g'8.[ 16] 8[ 8] 4 }
\score {
    \new Staff
    << 
    \new Voice { \voiceOne g'8.[ 16] 8[ 8] 4 }
    \new Voice { \voiceTwo d'8.[ 16] d'4 }
    >>
}

