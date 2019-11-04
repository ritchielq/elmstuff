module Audio.Update exposing (audioUpdate, audioUpdateCurrentTime)

import Array exposing (Array, set)
import Audio.Types exposing (..)
import Events exposing (AudioEventAction(..), Event(..), Events)


audioUpdateCurrentTime : AudioEntity -> Float -> AudioEntity
audioUpdateCurrentTime entityData time =
    { entityData | musicCurrentTime = time }


audioUpdate : AudioEntity -> Events -> ( AudioEntity, Events )
audioUpdate entityData events =
    let
        filteredEvents =
            List.filter
                (\event ->
                    case event of
                        AudioEvent _ ->
                            True

                        _ ->
                            False
                )
                events

        ( ( _, newMusic ), ( newMusicCurrentTime, newSound, newIndex ) ) =
            audioUpdateHelper ( filteredEvents, entityData.music ) ( entityData.musicCurrentTime, entityData.sound, entityData.index )

        newEntityData =
            { entityData | music = newMusic, musicCurrentTime = newMusicCurrentTime, sound = newSound, index = newIndex }
    in
    ( newEntityData, filteredEvents )


audioUpdateHelper : ( Events, AudioID ) -> ( Float, Array AudioID, Int ) -> ( ( Events, AudioID ), ( Float, Array AudioID, Int ) )
audioUpdateHelper ( events, music ) ( time, soundArr, index ) =
    let
        newIndex =
            modBy 10 (index + 1)

        event =
            List.head events
    in
    case event of
        Nothing ->
            ( ( events, music ), ( time, soundArr, index ) )

        Just e ->
            case e of
                AudioEvent action ->
                    case action of
                        StartMusic audioID ->
                            audioUpdateHelper ( List.drop 1 events, audioID ) ( 0, soundArr, index )

                        StopMusic ->
                            audioUpdateHelper ( List.drop 1 events, Silence ) ( 0, soundArr, index )

                        StartSound audioID ->
                            audioUpdateHelper ( List.drop 1 events, music ) ( time, Array.set newIndex Silence (Array.set index audioID soundArr), newIndex )

                _ ->
                    audioUpdateHelper ( List.drop 1 events, music ) ( time, soundArr, index )
