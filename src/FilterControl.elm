module FilterControl where

import String
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Filter exposing (Filter(Lowpass, Highpass))

-- Context

type alias Context =
  { filterPercentage: Int
  , updatePercentage: Signal.Address Int
  , filterType: Filter
  , updateType: Signal.Address Filter
  }

-- View

filters : List Filter
filters =
  [Lowpass, Highpass]

rangeToInt : (Int -> a) -> String -> a
rangeToInt mapper string =
  String.toInt string
    |> Result.withDefault 0
    |> mapper

view : Context -> Html
view context =
  div []
    [ p [] [ text "Filter" ]
    , viewSlider context
    , div [] (List.map (viewTypeSelector context) filters)
    ]

viewSlider : Context -> Html
viewSlider context =
  div []
    [ input
      [ type' "range"
      , Html.Attributes.min "0"
      , Html.Attributes.max "100"
      , on "input" targetValue (rangeToInt (Signal.message context.updatePercentage))
      , value (Basics.toString context.filterPercentage)
      ] []
    ]

viewTypeSelector : Context -> Filter -> Html
viewTypeSelector context filter =
  div []
    [ input
      [ type' "radio"
      , id (Filter.toString filter)
      , name "filterType"
      , checked (context.filterType == filter)
      , onClick context.updateType filter
      ] []
    , label [ for (Filter.toString filter) ] [ text (Basics.toString filter) ]
    ]
