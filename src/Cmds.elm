port module Cmds exposing (stop, start, setFilter)

import Waveform exposing (Waveform)
import Keys exposing (Key)
import Filter exposing (Filter)


port startRaw : ( String, Float ) -> Cmd msg


port stopRaw : () -> Cmd msg


port setFilterRaw : ( String, Int ) -> Cmd msg


start : Waveform -> Key -> Cmd msg
start waveform key =
    startRaw
        ( Waveform.toString waveform
        , Keys.toFrequency key
        )


stop : Cmd msg
stop =
    stopRaw ()


setFilter : Filter -> Int -> Cmd msg
setFilter filter percentage =
    setFilterRaw
        ( Filter.toString filter
        , percentage
        )
