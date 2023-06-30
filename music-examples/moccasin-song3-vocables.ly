\version "2.22"
\include "notes-in-text.ly"
\include "multi-lyrics.ly"

Music = { 
    \time 6/4
    r8 g'4 8 4 8[ 8] 2
}
LyricsA = \lyricmode {
    We: -- nu -- ye: we -- nu -- ye:
}
LyricsB = \lyricmode {
    Ga -- yo -- we: ga -- yo -- we:
}
\score {
    <<
    \new Staff
        <<
        \new Voice = "song" { \Music }
        \new Lyrics \lyricsto "song" { 
            <<
                { \LyricsA }
                \AddLyricsLine "song" "2" { \LyricsB }
            >>
        }
        >>
    >>
}

