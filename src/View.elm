module View exposing (view)

import String
import Html exposing (Html, div, p, label, text, input)
import Html.Attributes exposing (type', id, name, checked, for, value)
import Html.Events exposing (onClick, onInput)
import Model exposing (Model)
import Waveform exposing (Waveform(..))
import Filter exposing (Filter(..))
import Update exposing (Msg(..))


viewWaveform : Waveform -> Waveform -> Html Msg
viewWaveform currentWaveform waveform =
  div []
    [ input
      [ type' "radio"
      , id (Waveform.toString waveform)
      , name "oscillatorType"
      , checked (currentWaveform == waveform)
      , onClick (OscillatorChange waveform)
      ] []
    , label [ for (Waveform.toString waveform) ] [ text (Waveform.toString waveform) ]
    ]


viewWaveformSelector : Waveform -> Html Msg
viewWaveformSelector currentWaveform =
  div []
    [ p [] [ text "Oscillator" ]
    , div [] <| List.map (viewWaveform currentWaveform)  [Sawtooth, Square, Sine]
    ]


viewFilterSelector : Filter -> Int -> Html Msg
viewFilterSelector filterType percentage =
  div []
    [ p [] [ text "Filter" ]
    , viewSlider percentage
    , div [] <| List.map (viewTypeSelector filterType) [Lowpass, Highpass]
    ]


viewSlider : Int -> Html Msg
viewSlider percentage =
  div []
    [ input
      [ type' "range"
      , Html.Attributes.min "0"
      , Html.Attributes.max "100"
      , onInput <| String.toInt >> Result.withDefault 0 >> FilterFrequencyChange
      , value (toString percentage)
      ] []
    ]


viewTypeSelector : Filter -> Filter -> Html Msg
viewTypeSelector currentFilter filter =
  div []
    [ input
      [ type' "radio"
      , id (Filter.toString filter)
      , name "filterType"
      , checked (currentFilter == filter)
      , onClick <| FilterTypeChange filter
      ] []
    , label [ for (Filter.toString filter) ] [ text (Filter.toString filter) ]
    ]


view : Model -> Html Msg
view model =
  let
    currentKeyDisplay =
      case model.currentKey of
        Just key ->
          "Playing " ++ (toString key)
        Nothing ->
          "No key pressed"
  in
    div []
      [ p [] [ text "Use the middle and top rows of your keyboard like the keys of a piano" ]
      , p [] [ text currentKeyDisplay ]
      , viewWaveformSelector model.oscillatorType
      , viewFilterSelector model.filterType model.filterFrequency
      ]
