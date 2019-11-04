module Defaults exposing (defaultControlScheme, defaultInputs, defaultSize, defaultState, getScale)

import Audio.Create exposing (createAudio)
import Dict exposing (..)
import Settings.Types exposing (ControlScheme, Inputs, Settings)
import Types exposing (..)


defaultInputs : Inputs
defaultInputs =
    { down = 0
    , up = 0
    , left = 0
    , right = 0
    , esc = 0
    , action1 = 0
    , action2 = 0
    }


defaultControlScheme : ControlScheme
defaultControlScheme =
    { down = "ArrowDown"
    , up = "ArrowUp"
    , left = "ArrowLeft"
    , right = "ArrowRight"
    , esc = "p"
    , action1 = "z"
    , action2 = "x"
    }


defaultSize : { w : Int, h : Int }
defaultSize =
    { h = 1080, w = 1920 }


defaultState : State
defaultState =
    { entities = []
    , events = []
    , inputs = defaultInputs
    , rects = []
    , audioEntity = createAudio
    , resources = Dict.empty
    , toSeed = 0
    , settings =
        { windowSize = { innerWidth = 0, innerHeight = 0 }
        , controlScheme = defaultControlScheme
        }
    }


getScale : Settings -> Float
getScale settings =
    let
        scaleX =
            toFloat settings.windowSize.innerWidth / toFloat defaultSize.w

        scaleY =
            toFloat settings.windowSize.innerHeight / toFloat defaultSize.h
    in
    Basics.min scaleY scaleX
