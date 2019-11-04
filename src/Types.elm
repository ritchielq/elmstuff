module Types exposing (Msg(..), Point, State)

import Audio.Types exposing (AudioEntity, AudioID)
import Browser.Dom exposing (Viewport)
import Dict exposing (Dict)
import Entities.Types exposing (Entity, Rects)
import Events exposing (Events)
import Html.Events.Extra.Mouse as Pointer
import Settings.Types exposing (ControlScheme, Inputs, Settings, Size)
import Time exposing (Posix)
import WebGL.Texture exposing (Texture)


type alias State =
    { entities : List Entity
    , events : Events
    , inputs : Inputs
    , rects : Rects
    , audioEntity : AudioEntity
    , toSeed : Int
    , resources : Dict String Texture
    , settings : Settings
    }


type Msg
    = Frame Float
    | KeyDown String
    | KeyUp String
    | WindowSize Int Int
    | WindowInitSize Viewport
    | SpritesLoaded String (Maybe Texture)
    | MusicTimeUpdate Float
    | CreateInitialSeed Int
    | Click Pointer.Event


type alias Point =
    ( Float, Float )
