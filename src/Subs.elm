module Subs exposing (subscriptions)

import Model exposing (Model)
import Keys exposing (Key)
import Keyboard
import Update exposing (Msg(..))


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ downs model.currentKey
        , ups model.currentKey
        ]


downs : Maybe Key -> Sub Msg
downs maybeKey =
    let
        onKeyDown currentKey keyCode =
            if Keys.fromKeyCode keyCode == currentKey then
                NoOp
            else
                keyCode |> Keys.fromKeyCode |> KeyChange
    in
        Keyboard.downs (onKeyDown maybeKey)


ups : Maybe Key -> Sub Msg
ups maybeKey =
    let
        onKeyUp currentKeyCode keyCode =
            if Keys.fromKeyCode keyCode == Just currentKeyCode then
                KeyChange Nothing
            else
                NoOp
    in
        case maybeKey of
            Nothing ->
                Sub.none

            Just key ->
                Keyboard.ups (onKeyUp key)
