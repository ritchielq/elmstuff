module Audio.View exposing (audioView, onTimeUpdate, targetCurrentTime)

import Array exposing (..)
import Audio.Types exposing (..)
import Html exposing (Attribute, Html, div)
import Html.Attributes exposing (autoplay, hidden, loop, src)
import Html.Events exposing (on)
import Json.Decode as Json exposing (Decoder, map)
import Types exposing (Msg(..))


audioView : AudioEntity -> Html Msg
audioView entityData =
    div [] <|
        List.append
            [ Html.audio
                [ src <| fileName entityData.music
                , autoplay True
                , hidden True
                , loop True
                , onTimeUpdate MusicTimeUpdate
                ]
                []
            ]
            (Array.map
                (\sound ->
                    Html.audio
                        [ src <| fileName sound, autoplay True, hidden True ]
                        []
                )
                entityData.sound
                |> Array.toList
            )



-- Custom event handler


onTimeUpdate : (Float -> msg) -> Attribute msg
onTimeUpdate msg =
    on "timeupdate" (Json.map msg targetCurrentTime)



-- A `Json.Decoder` for grabbing `event.target.currentTime`.


targetCurrentTime : Json.Decoder Float
targetCurrentTime =
    Json.at [ "target", "currentTime" ] Json.float
