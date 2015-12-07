module OscillatorSelector where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Waveform exposing (Waveform(Sawtooth, Square, Sine))

-- Context

type alias Context =
  { selectWaveform: Signal.Address Waveform
  , currentWaveform: Waveform
  }

-- View

waveforms : List Waveform
waveforms =
  [Sawtooth, Square, Sine]


viewSelector : Context -> Waveform -> Html
viewSelector context waveform =
  div []
    [ input
      [ type' "radio"
      , id (Waveform.toString waveform)
      , name "oscillatorType"
      , checked (context.currentWaveform == waveform)
      , onClick context.selectWaveform waveform
      ] []
    , label [ for (Waveform.toString waveform) ] [ text (Basics.toString waveform) ]
    ]


view : Context -> Html
view context =
  div []
    [ p [] [ text "Oscillator" ]
    , div [] (List.map (viewSelector context) waveforms)
    ]
