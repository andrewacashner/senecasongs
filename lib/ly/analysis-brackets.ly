\version "2.22"

NB = \startGroup
endNB = \stopGroup

\layout {
  \context {
    \Score
    \override HorizontalBracket.direction = #UP
    \override HorizontalBracket.outside-staff-priority = #1500
  }
  \context {
    \Voice
    \consists "Horizontal_bracket_engraver"
  }
}
