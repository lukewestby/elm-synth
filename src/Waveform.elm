module Waveform
    exposing
        ( Waveform(..)
        , toString
        )

import String


type Waveform
    = Sawtooth
    | Square
    | Sine


toString : Waveform -> String
toString waveform =
    Basics.toString waveform
        |> String.toLower
