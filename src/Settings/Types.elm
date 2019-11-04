module Settings.Types exposing (ControlScheme, Inputs, Settings, Size)


type alias Settings =
    { windowSize : Size
    , controlScheme : ControlScheme
    }


type alias Size =
    { innerHeight : Int, innerWidth : Int }


type alias ControlScheme =
    { down : String
    , up : String
    , left : String
    , right : String
    , esc : String
    , action1 : String
    , action2 : String
    }


type alias Inputs =
    { down : Int
    , up : Int
    , left : Int
    , right : Int
    , esc : Int
    , action1 : Int
    , action2 : Int
    }
