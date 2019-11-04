module Main exposing (main)

import Browser exposing (element)
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyUp, onResize)
import Html exposing (..)
import Init exposing (..)
import Json.Decode as Decode
import Types exposing (..)
import Update exposing (tick)
import View exposing (display)


main : Program () State Msg
main =
    Browser.element
        { init = \() -> init
        , update = tick
        , view = display
        , subscriptions =
            \model ->
                Sub.batch
                    [ Browser.Events.onKeyDown (Decode.map KeyDown (Decode.field "key" Decode.string))
                    , Browser.Events.onKeyUp (Decode.map KeyUp (Decode.field "key" Decode.string))
                    , Browser.Events.onAnimationFrameDelta Frame
                    , Browser.Events.onResize WindowSize
                    ]
        }
