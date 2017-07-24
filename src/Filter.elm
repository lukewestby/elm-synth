module Filter
    exposing
        ( Filter(..)
        , toString
        )

import String


type Filter
    = Lowpass
    | Highpass


toString : Filter -> String
toString filter =
    Basics.toString filter
        |> String.toLower
