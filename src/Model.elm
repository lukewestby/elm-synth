module Model exposing (Model, model)

import Waveform exposing (Waveform(..))
import Filter exposing (Filter(..))
import Keys exposing (Key)


type alias Model =
    { oscillatorType : Waveform
    , filterFrequency : Int
    , filterType : Filter
    , currentKey : Maybe Key
    }


model : Model
model =
    { oscillatorType = Sawtooth
    , filterFrequency = 50
    , filterType = Lowpass
    , currentKey = Nothing
    }
