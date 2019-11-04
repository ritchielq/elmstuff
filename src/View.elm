module View exposing (display)

import Audio.View as Audio exposing (audioView)
import Css exposing (margin, padding, px)
import Css.Global exposing (body, global, html)
import Entities.View as Entities exposing (renderAllEntities)
import Html exposing (Html, div)
import Html.Styled exposing (toUnstyled)
import Types exposing (Msg, State)


display : State -> Html Msg
display state =
    div []
        [ toUnstyled (global [ body [ padding (px 0), margin (px 0) ] ])
        , div []
            [ Audio.audioView state.audioEntity ]
        , div
            []
            [ Entities.renderAllEntities state ]
        ]
