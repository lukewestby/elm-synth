module Keys (currentKey, toFrequency, Key) where

import Dict exposing (Dict)
import Char exposing (KeyCode)
import Maybe exposing (Maybe)
import Keyboard
import Set exposing (Set)

type Key
  = C3 | CS3 | D3 | DS3 | E3 | F3 | FS3 | G3 | GS3 | A3 | AS3 | B3
  | C4 | CS4 | D4


keyCodeToKey : Dict KeyCode Key
keyCodeToKey =
  Dict.fromList
    [ (65, C3)
    , (87, CS3)
    , (83, D3)
    , (69, DS3)
    , (68, E3)
    , (70, F3)
    , (84, FS3)
    , (71, G3)
    , (89, GS3)
    , (72, A3)
    , (85, AS3)
    , (74, B3)
    , (75, C4)
    , (79, CS4)
    , (76, D4)
    ]


fromKeyCode : KeyCode -> Maybe Key
fromKeyCode keyCode =
  Dict.get keyCode keyCodeToKey


toFrequency : Key -> Float
toFrequency key =
  case key of
    C3 -> 130.81
    CS3 -> 138.59
    D3 -> 146.83
    DS3 -> 155.56
    E3 -> 164.81
    F3 -> 174.61
    FS3 -> 185.0
    G3 -> 196.0
    GS3 -> 207.65
    A3 -> 220.0
    AS3 -> 233.08
    B3 -> 246.94
    C4 -> 261.63
    CS4 -> 277.18
    D4 -> 293.67


mapSignals : (Set KeyCode) -> KeyCode -> Maybe Key
mapSignals keysDown lastPressed =
  let
    adjusted = lastPressed - 32
  in
    if Set.member adjusted keysDown then
      fromKeyCode adjusted
    else
      Nothing


currentKey : Signal (Maybe Key)
currentKey =
  Signal.map2 mapSignals Keyboard.keysDown Keyboard.presses
    |> Signal.dropRepeats
