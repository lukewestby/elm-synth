module Main exposing (..)

import Html.App exposing (program)
import Subs exposing (subscriptions)
import Model exposing (model)
import View exposing (view)
import Update exposing (update, initialize)


main : Program Never
main =
    program
        { init = (model, initialize)
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
