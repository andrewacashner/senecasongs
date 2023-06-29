\version "2.22"
\include "font.ly"
\include "analysis-brackets.ly"

Song = {
    \clef "treble_8"
    \time 10/4
    \omit Staff.TimeSignature
    d'8[ d'8] e'8[ d'16 e'16]~ e'8[ f'8]
    d'8[ d'16 e'16]~ e'8[ c'16] r16
    g'8[ e'16 g'16]~ g'16[ e'16 d'8]~ d'8 d'8 
    g8[ g16 a16]~ a8[ a16] r16
}
Analysis = {
    \omit Staff.StaffSymbol
    \omit Staff.Clef
    \time 10/4
    s4 g'8\NB 4 8\endNB 8\NB 4 8\endNB 8\NB 4 8\endNB s4 g'8\NB 4 8\endNB
}
Lyrics = \lyricmode {
    Ga -- yo -- wa: -- ha -- ne -- we -- ha: -- wi -- no: -- ye’
    ga -- yo -- wa: -- ha -- ne: -- we -- ha: -- wi -- no: -- ye’
}
\score {
    <<
    \new Staff
        <<
        \new Voice { \Analysis }
        >>
    \new Staff
        <<
        \new Voice = "song" { \Song }
        \new Lyrics \lyricsto "song" { \Lyrics }
        >>
    >>
    \layout {
        \context {
            \Staff
                \omit TimeSignature
                \omit BarLine
            }
        \context {
            \Score
                \omit SystemStartBar
        }
    }
}
