module Update exposing (tick)

import Audio.Update as Audio exposing (audioUpdate, audioUpdateCurrentTime)
import Browser.Dom exposing (Viewport)
import Dict exposing (Dict)
import Entities.Rectangle exposing (clickedRect, updateRects)
import Entities.Update exposing (updateAllEntities)
import Inputs exposing (applyKey)
import Random exposing (initialSeed)
import Types exposing (..)


tick : Msg -> State -> ( State, Cmd Msg )
tick msg state =
    let
        set =
            state.settings

        spriteDict =
            state.resources

        input =
            state.inputs

        event =
            state.events

        rects =
            state.rects
    in
    case msg of
        Frame dt ->
            ( updateFrame state
            , Cmd.none
            )

        KeyDown key ->
            ( { state | inputs = applyKey input set key 1 }
            , Cmd.none
            )

        KeyUp key ->
            ( { state | inputs = applyKey input set key 0 }
            , Cmd.none
            )

        WindowSize w h ->
            ( { state | settings = { set | windowSize = { innerHeight = h, innerWidth = w } } }
            , Cmd.none
            )

        WindowInitSize view ->
            ( { state | settings = { set | windowSize = { innerHeight = round view.viewport.height, innerWidth = round view.viewport.width } } }
            , Cmd.none
            )

        SpritesLoaded spriteName texture ->
            case texture of
                Maybe.Nothing ->
                    ( state, Cmd.none )

                Maybe.Just t ->
                    ( { state | resources = Dict.insert spriteName t spriteDict }
                    , Cmd.none
                    )

        MusicTimeUpdate time ->
            ( { state | audioEntity = audioUpdateCurrentTime state.audioEntity time }
            , Cmd.none
            )

        CreateInitialSeed randomInt ->
            ( { state | toSeed = randomInt }, Cmd.none )

        Click point ->
            ( { state | events = clickedRect point.offsetPos state }, Cmd.none )


updateFrame : State -> State
updateFrame state =
    let
        { entities, events, inputs } =
            state

        entityFunctionResponse =
            List.map (updateAllEntities state) entities

        newEntities =
            List.filter
                (\en ->
                    Basics.not en.removeSelf
                )
                entityFunctionResponse
                |> List.map .entity
                |> List.append (List.concatMap .addEntities entityFunctionResponse)

        newEvents =
            List.map .events entityFunctionResponse
                |> List.concat

        ( newAudioEntity, finalEvents ) =
            audioUpdate state.audioEntity newEvents

        newRects =
            updateRects newEntities

        ( newToSeed, _ ) =
            Random.step (Random.int Random.minInt Random.maxInt) (Random.initialSeed state.toSeed)
    in
    { state | toSeed = newToSeed, entities = newEntities, events = newEvents, audioEntity = newAudioEntity, rects = newRects }
