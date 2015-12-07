module Waveform
  ( Waveform(Sawtooth, Square, Sine)
  , toString
  ) where

import String

type Waveform
  = Sawtooth
  | Square
  | Sine


toString : Waveform -> String
toString waveform =
  Basics.toString waveform
    |> String.toLower
