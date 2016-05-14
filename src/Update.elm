module Update exposing (Msg(..), update, initialize)

import Keys exposing (Key)
import Waveform exposing (Waveform(..))
import Filter exposing (Filter(..))
import Model exposing (Model)
import Cmds


type Msg
    = NoOp
    | KeyChange (Maybe Key)
    | OscillatorChange Waveform
    | FilterFrequencyChange Int
    | FilterTypeChange Filter


initialize : Cmd Msg
initialize =
    Cmd.none


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)
        KeyChange maybeKey ->
            case maybeKey of
                Nothing ->
                    ( { model | currentKey = maybeKey }
                    , Cmds.stop
                    )
                Just key ->
                    ( { model | currentKey = maybeKey }
                    , Cmds.start model.oscillatorType key
                    )
        OscillatorChange waveform ->
        case model.currentKey of
            Nothing ->
                ( { model | oscillatorType = waveform }
                , Cmd.none
                )
            Just key ->
                ( { model | oscillatorType = waveform }
                , Cmds.start waveform key
                )
        FilterFrequencyChange value ->
            ( { model | filterFrequency = value }
            , Cmds.setFilter model.filterType value
            )
        FilterTypeChange filterType ->
            ( { model | filterType = filterType }
            , Cmds.setFilter filterType model.filterFrequency
            )
