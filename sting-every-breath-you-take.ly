\version "2.20.0"

\header {
  title = "Every Breath You Take"
  subtitle = "見つめていたい"
  composer = "Sting"
  pdfarranger = "東 幸治"
  author = \markup \fromproperty #'header:composer
  subject = \markup \concat {
    "Bass partition for “"
    \fromproperty #'header:title
    "” by "
    \fromproperty #'header:composer
    "."
  }
  keywords = #(string-join '(
    "music"
    "partition"
    "bass"
  ) ", ")
  tagline = ##f
}

\paper {
  indent = 0\mm
  #(define fonts
    (set-global-fonts
     #:music "gonville"
     #:brace "gonville"
   ))
}

section =
#(define-music-function (text) (string?) #{
  \once \override Score.RehearsalMark.self-alignment-X = #RIGHT
  \once \override Score.RehearsalMark.padding = #2
  \mark \markup \override #'(thickness . 2) \rounded-box \bold #text
#})

DScoda = {
  \once \override Score.RehearsalMark.self-alignment-X = #RIGHT
  \once \override Score.RehearsalMark.direction = #DOWN
  \once \override Score.RehearsalMark.break-visibility = ##(#t #t #f)
  \mark \markup { \small "D.S. al Coda" }
}

toCoda = {
  \once \override Score.RehearsalMark.self-alignment-X = #RIGHT
  \once \override Score.RehearsalMark.direction = #DOWN
  \once \override Score.RehearsalMark.break-visibility = ##(#t #t #f)
  \mark \markup { \small "To Coda" }
}

intro = {
  \repeat percent 2 \repeat unfold 8 aes8
  \repeat percent 2 \repeat unfold 8 f
  \break
  \repeat unfold 8 des'
  \repeat unfold 8 ees\3
  \repeat percent 2 \repeat unfold 8 aes,
  \break
}

sectionA = {
  \repeat percent 2 \repeat unfold 8 aes8
  \repeat percent 2 \repeat unfold 8 f
  \break
  \repeat unfold 8 des'
  \repeat unfold 8 ees\3
  \repeat percent 2 \repeat unfold 8 f,
  \break
  \repeat percent 2 \repeat unfold 8 aes
  \repeat percent 2 \repeat unfold 8 f
  \break
  \repeat unfold 8 des'
  \repeat unfold 8 ees\3
  \repeat percent 2 \repeat unfold 8 aes,
  \break
}

sectionB = {
  <>
  -\tweak X-offset #-2
  ^\segno
  \repeat unfold 8 des8
  \repeat unfold 8 bes
  \repeat percent 2 \repeat unfold 8 aes
  \break
  \repeat percent 2 \repeat unfold 8 bes
  \repeat percent 2 \repeat unfold 8 ees\3
  \break
}

sectionAPrimeStart = {
  \repeat percent 2 \repeat unfold 8 aes,8
  \repeat percent 2 \repeat unfold 8 f
  \break
  \repeat unfold 8 des'
  \repeat unfold 8 ees\3
  \repeat percent 2 \repeat unfold 8 f,
}

sectionAPrime = #(define-music-function (scoreOnly) (boolean?) #{
  \sectionAPrimeStart
  \toCoda
  \break
  \repeat percent 2 { \repeat unfold 8 e'8\3 \noBreak }
  \repeat percent 2 { \repeat unfold 8 ges, \noBreak }
  #(if scoreOnly #{ \break #})
  \repeat percent 2 { \repeat unfold 8 e'\3 \noBreak }
  \repeat percent 2 { \repeat unfold 8 ges, \noBreak }
  \repeat percent 2 { \repeat unfold 8 e'\3 \noBreak }
  \break
  \repeat volta 2 {
    \repeat percent 2 \repeat unfold 8 aes,
    \repeat percent 2 \repeat unfold 8 f
    \break
    \repeat unfold 8 des'
    \repeat unfold 8 ees\3
  }
  \alternative {
    \repeat percent 2 \repeat unfold 8 f,
    \repeat percent 2 \repeat unfold 8 aes
  }
  \DScoda
  \break
#})

sectionAPrimeCoda = {
  <>
  -\tweak X-offset #-2
  ^\coda
  \repeat unfold 8 des8
  \repeat unfold 8 ees\3
  \repeat percent 4 \repeat unfold 8 f,
  \break
}

outro = {
  \repeat volta 2 {
    \repeat percent 2 \repeat unfold 8 aes8
    \repeat unfold 8 f
    \repeat unfold 8 des'
  }
}

song = #(define-music-function (scoreOnly) (boolean?) #{
  \relative c, {
    \section "Intro"
    \intro
    \section "A"
    \sectionA
    \section "B"
    \sectionB
    \section "A′"
    \sectionAPrime #scoreOnly
    \sectionAPrimeCoda
    \section "Out"
    \outro
  }
#})

staves = #(define-music-function (scoreOnly) (boolean?) #{
  \new StaffGroup <<
    \new ChordNames {
      \set chordChanges = ##t
      \chordmode {
        % Intro
        aes1:9 q f:m9 q
        des:9 ees:9 aes:9 q
        % A
        aes1:9 q f:m9 q
        des:9 ees:9 f:m9 q
        aes1:9 q f:m9 q
        des:9 ees:9 aes:9 q
        % B
        des:9 des/b aes:9 q
        bes:9 q ees:9 q
        % A′
        aes:9 q f:m9 q
        des:9 ees:9 f:m9 q
        \repeat unfold 2 {
          e q ges q
        }
        e q
        \repeat volta 2 {
          aes:9 q f:m9 q
          des:9 ees:9
        }
        \alternative {
          { f:m9 q }
          { aes:9 q }
        }
        des:9 ees:9 f:m9 q q q
        % Outro
        aes:9 q f:m9 des:9
      }
    }

    \new Staff {
      \override Score.MetronomeMark.self-alignment-X = #RIGHT
      \tempo 4 = 117
      \clef "bass_8"
      \key f \minor
      \numericTimeSignature
      \time 4/4
      \song #scoreOnly
    }

    #(if (not scoreOnly) #{
      \new TabStaff \with {
        stringTunings = #bass-tuning
      } {
        \clef "moderntab"
        \song #scoreOnly
      }
    #})
  >>
#})

\book {
  \score {
    \staves ##f
    \layout {
      \context Voice
      \omit StringNumber
    }
  }

  \score {
    \unfoldRepeats \new Staff \with {
      midiInstrument = #"electric bass (pick)"
    } {
      \tempo 4 = 117
      \time 4/4

      \intro
      \sectionA
      \sectionB
      \sectionAPrime ##f
      \sectionB
      \sectionAPrimeStart
      \sectionAPrimeCoda
      \outro
    }
    \midi { }
  }
}

\book {
  \bookOutputSuffix "score-only"

  \header {
    pdftitle = \markup \concat { \fromproperty #'header:title " (Score)" }
  }

  \paper {
    markup-system-spacing.padding = #3
    system-system-spacing.padding = #5
  }

  \score {
    \staves ##t
    \layout {
      \omit Voice.StringNumber
    }
  }
}
