\version "2.22"
%%****************************************
%% MULTI-STANZA LYRICS
%% Add a new line of lyrics below previous line

%% Usage
%% in score: 
%% \new Staff = "s-SI"
%%   <<
%%      \new Voice = "SI" { \MusicSI }
%%      \new Lyrics = "SI-1" \lyricsto "SI" { \LyricsSI }
%%   >>
%%
%% in lyrics:
%% LyricsSI = \lyricmode {
%%   <<
%%      {
%%        \StanzaI
%%        First __ _ stan -- za ly -- rics.
%%      }
%%      \NextLyricsLine "SI-2" "SI-1" "SI"
%%      {
%%        \StanzaII
%%        Se -- cond stan -- za ly -- rics.
%%      }
%%%     \NextLyricsLine "SI-3" "SI-2" "SI"
%%      {
%%        \StanzaIII
%%        Third __ _ stan -- za ly -- rics.
%%      }
%%   >>
%%

NextLyricsLine = 
#(define-scheme-function
  (NewLineName PrevLineName Voice Lyrics)
  (markup? markup? markup? ly:music?)
  #{
  \new Lyrics = $NewLineName
  \with { alignBelowContext = $PrevLineName }
  { \set associatedVoice = $Voice $Lyrics }
  #})

%% Shortcut for the above:
%% LyricsSI = \lyricmode {
%%   <<
%%      {
%%        \StanzaI
%%        First __ _ stan -- za ly -- rics.
%%      }
%%      \AddLyricsLine "SI" "2" {
%%        \StanzaII
%%        Se -- cond stan -- za ly -- rics.
%%      }
%%      \AddLyricsLine "SI" "3" {
%%        \StanzaIII
%%        Third __ _ stan -- za ly -- rics.
%%      }
%%   >>
%%
AddLyricsLine =
#(define-scheme-function
   (voice n lyrics) 
   (string? string? ly:music?)
   (let* ((n (string->number n))
          (prev (format #f "~a-~a" voice (1- n)))
          (this (format #f "~a-~a" voice n)))
     (NextLyricsLine this prev voice lyrics)))


