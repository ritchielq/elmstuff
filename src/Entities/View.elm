module Entities.View exposing (renderAllEntities)

import Defaults exposing (defaultSize, getScale)
import Dict exposing (Dict)
import Entities.TextureShader exposing (..)
import Entities.Types as Entities exposing (..)
import Html exposing (Html)
import Html.Attributes exposing (height, style, width)
import Html.Events.Extra.Mouse as Pointer
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Sprite exposing (..)
import Types exposing (Msg, Point, State)
import WebGL exposing (Entity)
import WebGL.Settings.DepthTest as DepthTest
import WebGL.Texture as Texture exposing (size)


blockRenderFunction : State -> BlockEntityData -> List WebGL.Entity
blockRenderFunction state entityData =
    let
        x =
            entityData.x

        y =
            entityData.y

        ( r, g, b ) =
            entityData.color

        scale =
            getScale state.settings
    in
    [ WebGL.entityWith [ DepthTest.default ]
        vertexShader
        fragmentShader
        box
        { offset = vec3 x y 4
        , frameSize = vec2 200 200
        , scale = 1
        , color = vec3 r g b
        }
    ]


ballRenderFunction : State -> BallEntityData -> List WebGL.Entity
ballRenderFunction state entityData =
    let
        x =
            entityData.x

        y =
            entityData.y
    in
    [ WebGL.entityWith [ DepthTest.default ]
        vertexShader
        fragmentShader
        box
        { offset = vec3 x y 4
        , frameSize = vec2 100 100
        , scale = 1
        , color = vec3 1 1 1
        }
    ]


playerRenderFunction : State -> PlayerEntityData -> List WebGL.Entity
playerRenderFunction state entityData =
    let
        x =
            entityData.x

        y =
            entityData.y

        aF =
            entityData.animationFrame // 5

        aS =
            entityData.animationState

        mirror =
            entityData.mirror

        playerTexture =
            Dict.get (Sprite.filename PlayerTexture) state.resources

        scale =
            getScale state.settings
    in
    case playerTexture of
        Maybe.Nothing ->
            []

        Maybe.Just playerText ->
            [ WebGL.entityWith [ DepthTest.default ]
                texturedVertexShader
                texturedFragmentShader
                box
                { offset = vec3 x y 4
                , texture = playerText
                , mirror = mirror
                , textureSize = vec2 (toFloat (Tuple.first (Texture.size playerText))) (toFloat (Tuple.second (Texture.size playerText)))
                , frameSize = vec2 200 200
                , scale = 1
                , textureOffset = vec2 (toFloat (200 * aF)) (toFloat (200 * aS))
                }
            ]


renderAllEntities : State -> Html.Html Msg
renderAllEntities state =
    WebGL.toHtmlWith
        [ WebGL.depth 1
        , WebGL.stencil 0
        , WebGL.clearColor (22 / 255) (17 / 255) (22 / 255) 0
        ]
        [ width (round (toFloat defaultSize.w * getScale state.settings))
        , height (round (toFloat defaultSize.h * getScale state.settings))
        , style "display" "block"
        , style "position" "absolute"
        , style "margin" "0"
        , style "padding" "0"
        , style "margin-top" ("" ++ String.fromFloat ((toFloat state.settings.windowSize.innerHeight - toFloat defaultSize.h * getScale state.settings) / 2) ++ "px")
        , style "margin-left" ("" ++ String.fromFloat ((toFloat state.settings.windowSize.innerWidth - toFloat defaultSize.w * getScale state.settings) / 2) ++ "px")
        , style "image-rendering" "optimizeSpeed"
        , style "image-rendering" "-moz-crisp-edges"
        , style "image-rendering" "-webkit-optimize-contrast"
        , style "image-rendering" "crisp-edges"
        , style "image-rendering" "pixelated"
        , style "-ms-interpolation-mode" "nearest-neighbor"
        , Pointer.onClick Types.Click
        ]
        (List.concatMap (useRenderFunction state) state.entities)


useRenderFunction : State -> Entities.Entity -> List WebGL.Entity
useRenderFunction state entity =
    case entity of
        PlayerEntity entityData ->
            playerRenderFunction state entityData

        BallEntity entityData ->
            ballRenderFunction state entityData

        BlockEntity entityData ->
            blockRenderFunction state entityData
