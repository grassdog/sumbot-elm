module Global.Update exposing (update)

import Model as Main
import Msg as Main exposing (..)
import Global.Model exposing (Model)
import Global.Msg as Global exposing (..)


update : Main.Msg -> Main.Model -> Model
update msgFor mainModel =
    case msgFor of
        MsgForGlobal msg ->
            updateGlobal msg mainModel

        _ ->
            mainModel.global


updateGlobal : Global.Msg -> Main.Model -> Model
updateGlobal msg mainModel =
    case msg of
        Global.NoOp ->
            mainModel.global
