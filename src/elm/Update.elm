module Update exposing (..)

import Msg exposing (Msg)
import Model exposing (Model)
import Global.Update as Global
import TransactionList.Update as TransactionList


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


updateWithCmd : Msg -> Model -> ( Model, Cmd Msg )
updateWithCmd msg model =
    ( update msg model, updateCmd msg )


update : Msg -> Model -> Model
update msg model =
    { model
        | global = Global.update msg model
        , transactionList = TransactionList.update msg model
    }


updateCmd : Msg -> Cmd Msg
updateCmd msg =
    Cmd.none



-- TODO Use this instead of Cmd.none above if I have commands
-- Cmd.batch
--     [ Task.updateTaskCmd focus msg
--     ]
