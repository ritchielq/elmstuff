module Entities.Update exposing (updateAllEntities)

import Audio.Types as Audio exposing (AudioID)
import Entities.Types exposing (..)
import Events exposing (..)
import Random as Random
import Types exposing (State)


updateAllEntities : State -> Entity -> { entity : Entity, events : Events, addEntities : AddEntities, removeSelf : Bool }
updateAllEntities state entity =
    case entity of
        PlayerEntity entityData ->
            playerUpdate state entityData

        BlockEntity entityData ->
            blockUpdate state entityData

        BallEntity entityData ->
            ballUpdate state entityData


ballUpdate : State -> BallEntityData -> { entity : Entity, events : Events, addEntities : AddEntities, removeSelf : Bool }
ballUpdate { events, entities } entityData =
    if List.member (GameSceneEvent Pause) events == True then
        { entity = BallEntity entityData, events = [], addEntities = [], removeSelf = False }

    else if List.member (GameSceneEvent Kill) events == True then
        { entity = BallEntity entityData, events = [], addEntities = [], removeSelf = True }

    else
        let
            leftWall =
                List.map
                    (\en ->
                        case en of
                            BlockEntity dt ->
                                dt.x

                            _ ->
                                -1
                    )
                    entities
                    |> List.filter (\x -> x > 0)

            rightWall =
                List.map
                    (\en ->
                        case en of
                            BlockEntity dt ->
                                dt.x + 200

                            _ ->
                                -1
                    )
                    entities
                    |> List.filter (\x -> x > 0)

            swapDx =
                if entityData.dx > 0 then
                    if
                        List.filter
                            (\wallPos ->
                                entityData.x + 100 < wallPos
                            )
                            leftWall
                            |> List.isEmpty
                    then
                        -1

                    else
                        1

                else if
                    List.filter
                        (\wallPos ->
                            entityData.x > wallPos
                        )
                        rightWall
                        |> List.isEmpty
                then
                    -1

                else
                    1

            newEvents =
                if swapDx < 0 then
                    [ BlockEvent <| ChangeColor ]

                else
                    []

            newData =
                { entityData
                    | x = entityData.x + entityData.dx * swapDx
                    , dx = entityData.dx * swapDx
                }
        in
        { entity =
            BallEntity
                newData
        , events = newEvents
        , addEntities = []
        , removeSelf = False
        }


blockUpdate : State -> BlockEntityData -> { entity : Entity, events : Events, addEntities : AddEntities, removeSelf : Bool }
blockUpdate { events, toSeed } entityData =
    if List.member (GameSceneEvent Kill) events == True then
        { entity = BlockEntity entityData, events = [], addEntities = [], removeSelf = True }

    else if List.member (BlockEvent ChangeColor) events == True then
        let
            zeroToOneGen =
                Random.float 0 1

            ( r, seed1 ) =
                Random.step zeroToOneGen (Random.initialSeed (toSeed + entityData.seedOffset))

            ( g, seed2 ) =
                Random.step zeroToOneGen seed1

            ( b, _ ) =
                Random.step zeroToOneGen seed2

            newData =
                { entityData | color = ( r, g, b ) }
        in
        { entity =
            BlockEntity
                newData
        , events = []
        , addEntities = []
        , removeSelf = False
        }

    else
        { entity = BlockEntity entityData, events = [], addEntities = [], removeSelf = False }


playerUpdate : State -> PlayerEntityData -> { entity : Entity, events : Events, addEntities : AddEntities, removeSelf : Bool }
playerUpdate { events, inputs } entityData =
    if List.member (GameSceneEvent Pause) events == True then
        { entity = PlayerEntity entityData, events = [], addEntities = [], removeSelf = False }

    else if List.member (GameSceneEvent Kill) events == True then
        { entity = PlayerEntity entityData, events = [], addEntities = [], removeSelf = True }

    else
        let
            x =
                entityData.x

            y =
                entityData.y

            ti =
                entityData.takingInputs

            amountX =
                toFloat (ti * 5 * (inputs.right - inputs.left))

            amountY =
                toFloat (ti * 5 * (inputs.up - inputs.down))

            aF =
                modBy 25 (entityData.animationFrame + 1)

            aS =
                max inputs.right inputs.left
                    |> max inputs.up
                    |> max inputs.down

            mirror =
                negate (toFloat inputs.left - 0.5) * 2

            clicked =
                events
                    |> (\_ ->
                            if List.member (PlayerEvent Clicked) events == True then
                                1

                            else
                                0
                       )

            -- Firing
            fire =
                (\click cd ->
                    if cd == 0 then
                        click

                    else
                        0
                )
                    clicked
                    entityData.fireCD

            newFireCD =
                if fire == 1 then
                    3

                else
                    max (entityData.fireCD - 1) 0

            -- Create newEvents
            newEvents =
                List.concat <|
                    (\fired ->
                        if fired == 1 then
                            [ AudioEvent <| StartSound <| Audio.Fire ]

                        else
                            []
                    )
                        fire
                        :: []

            -- Create newData
            newData =
                { entityData
                    | x =
                        (\tx tamountX -> tx + tamountX) x amountX
                    , y =
                        (\ty tamountY -> ty - tamountY) y amountY
                    , animationFrame = aF
                    , animationState = aS
                    , mirror = mirror
                    , takingInputs = entityData.takingInputs
                    , fireCD = newFireCD
                }
        in
        { entity =
            PlayerEntity
                newData
        , events = newEvents
        , addEntities = []
        , removeSelf = False
        }
