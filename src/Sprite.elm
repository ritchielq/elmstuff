module Sprite exposing (TextureId(..), filename, loadSprites, texturesToLoad)

import Task
import Types exposing (Msg(..))
import WebGL.Texture as Texture exposing (Error, defaultOptions)


type TextureId
    = PlayerTexture
    | CrateTexture


loadSprites : TextureId -> Cmd Msg
loadSprites textureId =
    let
        fileString =
            filename textureId
    in
    Texture.loadWith { defaultOptions | horizontalWrap = Texture.clampToEdge, verticalWrap = Texture.clampToEdge, flipY = False }
        ("img/" ++ fileString)
        |> Task.attempt (Result.toMaybe >> SpritesLoaded fileString)


filename : TextureId -> String
filename textureId =
    case textureId of
        PlayerTexture ->
            "hehe.png"

        CrateTexture ->
            "crate.jpg"


texturesToLoad : List TextureId
texturesToLoad =
    [ PlayerTexture, CrateTexture ]
