module Inputs exposing (applyKey)

import Settings.Types exposing (Inputs, Settings)


applyKey : Inputs -> Settings -> String -> Int -> Inputs
applyKey inputs settings keycode int =
    if keycode == settings.controlScheme.left then
        { inputs | left = int }

    else if keycode == settings.controlScheme.up then
        { inputs | up = int }

    else if keycode == settings.controlScheme.right then
        { inputs | right = int }

    else if keycode == settings.controlScheme.down then
        { inputs | down = int }

    else if keycode == settings.controlScheme.esc then
        { inputs | esc = int }

    else if keycode == settings.controlScheme.action1 then
        { inputs | action1 = int }

    else if keycode == settings.controlScheme.action2 then
        { inputs | action2 = int }

    else
        inputs
