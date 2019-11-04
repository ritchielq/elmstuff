module Audio.Types exposing (AudioEntity, AudioID(..), fileName)

import Array exposing (Array)


type AudioID
    = Silence
    | Fire
    | Whimsical


type alias AudioEntity =
    { music : AudioID
    , musicCurrentTime : Float
    , sound : Array AudioID
    , index : Int
    }


fileName : AudioID -> String
fileName audioID =
    case audioID of
        Silence ->
            ""

        Fire ->
            "sound/fire.ogg"

        Whimsical ->
            "sound/Whimsical.ogg"
