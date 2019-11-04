module Entities.Types exposing (AddEntities, BallEntityData, BlockEntityData, Entity(..), PlayerEntityData, Rect, Rects)

import Events exposing (Event)


type alias AddEntities =
    List Entity


type Entity
    = PlayerEntity PlayerEntityData
    | BlockEntity BlockEntityData
    | BallEntity BallEntityData


type alias BallEntityData =
    { x : Float
    , y : Float
    , dx : Float
    }


type alias BlockEntityData =
    { x : Float
    , y : Float
    , color : ( Float, Float, Float )
    , seedOffset : Int
    }


type alias PlayerEntityData =
    { takingInputs : Int
    , x : Float
    , y : Float
    , animationFrame : Int
    , animationState : Int
    , mirror : Float
    , fireCD : Int
    , seedOffset : Int
    }


type alias Rects =
    List Rect


type alias Rect =
    { x : Float
    , y : Float
    , w : Float
    , h : Float
    , event : Event
    }
