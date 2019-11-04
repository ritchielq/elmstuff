module Audio.Create exposing (createAudio)

import Array exposing (repeat)
import Audio.Types exposing (..)


createAudio : AudioEntity
createAudio =
    { music = Silence 
    , musicCurrentTime = 0.0
    , sound = Array.repeat 10 Silence
    , index = 0
    }
