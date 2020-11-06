\version "2.20.0"

\header {
  title = "Every Breath You Take"
  composer = "The Police"
  pdfarranger = "東 幸治"
  author = \markup \fromproperty #'header:composer
  subject = \markup \concat { \fromproperty #'header:title " Bass Partition" }
  keywords = #(string-join '(
    "music"
    "partition"
    "bass"
  ) ", ")
  tagline = ##f
}

\paper {
  indent = 0\mm
}

section =
#(define-music-function
     (text)
     (string?)
   #{
     \once \override Score.RehearsalMark.self-alignment-X = #RIGHT
     \once \override Score.RehearsalMark.padding = #2
     \mark \markup \rounded-box \bold #text
   #})

DScoda = {
  \once \override Score.RehearsalMark.self-alignment-X = #RIGHT
  \once \override Score.RehearsalMark.direction = #DOWN
  \once \override Score.RehearsalMark.break-visibility = ##(#t #t #f)
  \mark \markup { \small "D.S. al Coda" }
}

ToCoda = {
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
  \repeat percent 2 \repeat unfold 8 aes
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
  \repeat unfold 8 des
  \repeat unfold 8 bes
  \repeat percent 2 \repeat unfold 8 aes
  \break
  \repeat percent 2 \repeat unfold 8 bes
  \repeat percent 2 \repeat unfold 8 ees\3
  \break
}

sectionAPrimeStart = {
  \repeat percent 2 \repeat unfold 8 aes,
  \repeat percent 2 \repeat unfold 8 f
  \break
  \repeat unfold 8 des'
  \repeat unfold 8 ees\3
  \repeat percent 2 \repeat unfold 8 f,
}

sectionAPrime = {
  \sectionAPrimeStart
  \ToCoda
  \break
  \repeat unfold 3 {
    \repeat percent 2 \repeat unfold 8 ees'\3
    \repeat percent 2 \repeat unfold 8 ges,
  }
  \break
  \repeat volta 2 {
    \repeat percent 2 \repeat unfold 8 aes
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
}

sectionAPrimeCoda = {
  <>
  -\tweak X-offset #-2
  ^\coda
  \repeat unfold 8 des
  \repeat unfold 8 ees\3
  \repeat percent 4 \repeat unfold 8 f,
  \break
}

outro = {
  \repeat volta 2 {
    \repeat percent 2 \repeat unfold 8 aes
    \repeat unfold 8 f
    \repeat unfold 8 des'
  }
}

song = \relative c, {
  \section "Intro"
  \intro
  \section "A"
  \sectionA
  \section "B"
  \sectionB
  \section "A′"
  \sectionAPrime
  \sectionAPrimeCoda
  \section "Outro"
  \outro
}

staves = #(define-music-function (scoreOnly) (boolean?) #{
  \new StaffGroup <<
    \new ChordNames {
      % \set additionalPitchPrefix = "add"
      \chords {
        % Intro
        aes1:9 s f:m9 s
        des:9 ees:9 aes:9 s
        % A
        aes1:9 s f:m9 s
        des:9 ees:9 f:m9 s
        aes1:9 s f:m9 s
        des:9 ees:9 aes:9 s
        % B
        des:9 des/b aes:9 s
        bes:9 s ees:9 s
        % A′
        aes:9 s f:m9 s
        des:9 ees:9 f:m9 s
        \repeat unfold 3 {
          e s ges s
        }
        \repeat volta 2 {
          aes:9 s f:m9 s
          des:9 ees:9
        }
        \alternative {
          { f:m9 s }
          { aes:9 s }
        }
        des:9 ees:9 f:m9 s s s
        % Outro
        aes:9 s f:m9 des:9
      }
    }

    \new Staff {
      \override Score.MetronomeMark.self-alignment-X = #RIGHT
      \tempo 4 = 117
      \clef "bass_8"
      \key f \minor
      \numericTimeSignature
      \time 4/4
      \song
    }

    #(if (not scoreOnly) #{
      \new TabStaff \with {
        stringTunings = #bass-tuning
      } {
        \clef "moderntab"
        \song
      }
    #})
  >>
#})

\book {
  \score {
    \staves ##f
    \layout {
      \omit Voice.StringNumber
    }
  }

  \score {
  \unfoldRepeats \new Staff \with {
      midiInstrument = #"electric bass (finger)"
    } {
      \tempo 4 = 117
      \time 4/4

      \intro
      \sectionA
      \sectionB
      \sectionAPrime
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
    markup-system-spacing.padding = #5
    system-system-spacing.padding = #8
  }

  \score {
    \staves ##t
    \layout {
      \omit Voice.StringNumber
    }
  }
}
