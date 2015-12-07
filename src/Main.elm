module Main where

import Task exposing (Task)
import StartApp
import Maybe exposing (Maybe)
import Effects exposing (Effects)
import Html exposing (..)
import Keys
import Waveform exposing (Waveform(Sawtooth, Sine, Square))
import Filter exposing (Filter(Highpass, Lowpass))
import Audio
import OscillatorSelector
import FilterControl

-- Model

type alias Model =
  { oscillatorType: Waveform
  , filterFrequency: Int
  , filterType: Filter
  , currentKey: Maybe Keys.Key
  }


initialModel : Model
initialModel =
  { oscillatorType = Sawtooth
  , filterFrequency = 50
  , filterType = Lowpass
  , currentKey = Nothing
  }


initialEffects : Effects Action
initialEffects =
  Effects.none


init : (Model, Effects Action)
init =
  (initialModel, initialEffects)

-- Update

type Action
  = None
  | KeyChange (Maybe Keys.Key)
  | OscillatorChange Waveform
  | FilterFrequencyChange Int
  | FilterTypeChange Filter


update : Action -> Model -> (Model, Effects Action)
update action model =
  Debug.log "model" <|
    case action of
      None ->
        (model, Effects.none)
      KeyChange maybeKey ->
        ( { model | currentKey = maybeKey }, Effects.none )
      OscillatorChange waveform ->
        ( { model | oscillatorType = waveform }, Effects.none )
      FilterFrequencyChange value ->
        ( { model | filterFrequency = value }, Effects.none )
      FilterTypeChange filterType ->
        ( { model | filterType = filterType }, Effects.none )

-- View

view : Signal.Address Action -> Model -> Html
view address model =
  let
    oscillatorSelectorContext =
      OscillatorSelector.Context
        (Signal.forwardTo address OscillatorChange)
        model.oscillatorType

    filterControlContext =
      FilterControl.Context
        (model.filterFrequency)
        (Signal.forwardTo address FilterFrequencyChange)
        (model.filterType)
        (Signal.forwardTo address FilterTypeChange)

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
      , OscillatorSelector.view oscillatorSelectorContext
      , FilterControl.view filterControlContext
      ]

-- Inputs

inputs : List (Signal Action)
inputs =
  [currentKeyAction]


currentKeyAction : Signal Action
currentKeyAction =
  Signal.map KeyChange Keys.currentKey

-- StartApp

app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = inputs
    }


main : Signal Html
main =
  app.html


port tasks : Signal (Task Effects.Never ())
port tasks =
  app.tasks


port updatePlayState : Signal (Task never ())
port updatePlayState =
  let
    toOutput model =
      (model.oscillatorType, model.currentKey)
    update (oscType, maybeKey) =
      case maybeKey of
        Just key ->
          Audio.start oscType key
        Nothing ->
          Audio.stop ()
  in
    Signal.map toOutput app.model
      |> Signal.dropRepeats
      |> Signal.map update


port updateFilter : Signal (Task never ())
port updateFilter =
  let
    update model =
      Audio.setFilter model.filterType model.filterFrequency
  in
    Signal.map update app.model
