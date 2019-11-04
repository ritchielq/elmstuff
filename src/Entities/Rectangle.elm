module Entities.Rectangle exposing (clickedRect, getClickEvent, playerEntityRect, updateRect, updateRects)

import Defaults exposing (getScale)
import Entities.Types exposing (..)
import Events exposing (..)
import Types exposing (Point, State)


updateRects : List Entity -> Rects
updateRects entity =
    List.map updateRect entity


updateRect : Entity -> Rect
updateRect entity =
    case entity of
        PlayerEntity data ->
            playerEntityRect data

        _ ->
            noRect


noRect : Rect
noRect =
    { x = 0, y = 0, w = 0, h = 0, event = DummyEvent }


playerEntityRect : PlayerEntityData -> Rect
playerEntityRect data =
    let
        x =
            data.x

        y =
            data.y

        event =
            PlayerEvent Clicked
    in
    { x = x
    , y = y
    , w = 200
    , h = 200
    , event = event
    }


clickedRect : Point -> State -> Events
clickedRect point { settings, rects, events } =
    let
        scale =
            getScale settings

        ( ( _, _, _ ), clickEvent ) =
            getClickEvent ( rects, point, scale ) Nothing

        newEvents =
            case clickEvent of
                Just cEvent ->
                    cEvent :: events

                Nothing ->
                    events
    in
    newEvents


getClickEvent : ( Rects, Point, Float ) -> Maybe Event -> ( ( Rects, Point, Float ), Maybe Event )
getClickEvent ( rects, ( pointx, pointy ), scale ) clickEvent =
    let
        rect =
            List.head rects
    in
    case rect of
        Nothing ->
            ( ( rects, ( pointx, pointy ), scale ), Maybe.Nothing )

        Just rec ->
            let
                x1 =
                    rec.x * scale

                x2 =
                    x1 + scale * rec.w

                inX =
                    x1 <= pointx && pointx <= x2

                y1 =
                    rec.y * scale

                y2 =
                    y1 + scale * rec.h

                inY =
                    y1 <= pointy && pointy <= y2
            in
            if inX && inY then
                ( ( rects, ( pointx, pointy ), scale ), Maybe.Just rec.event )

            else
                getClickEvent ( List.drop 1 rects, ( pointx, pointy ), scale ) Maybe.Nothing
