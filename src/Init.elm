module Init exposing (init)

import Browser.Dom exposing (getViewport)
import Defaults exposing (defaultState)
import Entities.Create exposing (..)
import Random exposing (generate, int, maxInt, minInt)
import Sprite exposing (..)
import Task
import Types exposing (Msg(..), State)


createEntities : State
createEntities =
    { defaultState | entities = (++) defaultState.entities (createBall :: createBlock 1100 :: createBlock 0 :: List.singleton createPlayer) }


init : ( State, Cmd Msg )
init =
    let
        state =
            createEntities
    in
    ( state
    , Cmd.batch
        (Task.perform WindowInitSize getViewport
            :: Random.generate CreateInitialSeed (Random.int minInt maxInt)
            :: List.map Sprite.loadSprites Sprite.texturesToLoad
        )
    )
