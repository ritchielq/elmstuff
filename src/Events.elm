module Events exposing (AudioEventAction(..), BlockEventAction(..), Event(..), Events, GameSceneEventAction(..), PlayerEventAction(..))

import Audio.Types exposing (AudioID)


type alias Events =
    List Event


type Event
    = GameSceneEvent GameSceneEventAction
    | PlayerEvent PlayerEventAction
    | AudioEvent AudioEventAction
    | BlockEvent BlockEventAction
    | DummyEvent


type GameSceneEventAction
    = Pause
    | Kill


type PlayerEventAction
    = Hit Float
    | Clicked


type BlockEventAction
    = ChangeColor


type AudioEventAction
    = StartMusic AudioID
    | StopMusic
    | StartSound AudioID
