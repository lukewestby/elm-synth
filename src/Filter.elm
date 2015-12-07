module Filter
  ( Filter(Lowpass, Highpass)
  , toString
  ) where

import String

type Filter
  = Lowpass
  | Highpass


toString : Filter -> String
toString filter =
  Basics.toString filter
    |> String.toLower
