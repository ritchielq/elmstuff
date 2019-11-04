module Entities.Create exposing (createBall, createBlock, createPlayer)

import Entities.Types exposing (..)


createPlayer : Entity
createPlayer =
    PlayerEntity
        { takingInputs = 1
        , x = 0
        , y = 0
        , animationFrame = 0
        , animationState = 0
        , mirror = 0
        , fireCD = 0
        , seedOffset = 0
        }


createBlock : Int -> Entity
createBlock pos =
    BlockEntity
        { x = 300 + toFloat pos
        , y = 700
        , color = ( 1, 1, 1 )
        , seedOffset = pos
        }


createBall : Entity
createBall =
    BallEntity { x = 550, y = 750, dx = 30 }
