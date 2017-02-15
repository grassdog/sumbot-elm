module Main exposing (..)

import Html
import Model
import Update
import View
import Msg


main : Program Model.Flags Model.Model Msg.Msg
main =
    Html.programWithFlags
        { init = Model.init
        , update = Update.updateWithCmd
        , subscriptions = Update.subscriptions
        , view = View.rootView
        }
