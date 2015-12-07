module Audio where

import Native.Audio
import Task exposing (Task)
import Keys
import Waveform
import Filter

start : Waveform.Waveform -> Keys.Key -> Task never ()
start oscWaveform key =
  Native.Audio.start
    (Waveform.toString oscWaveform)
    (Keys.toFrequency key)


setFilter : Filter.Filter -> Int -> Task never ()
setFilter filterType filterPercentage =
  Native.Audio.setFilter
    (Filter.toString filterType)
    filterPercentage


stop: () -> Task never ()
stop = Native.Audio.stop
