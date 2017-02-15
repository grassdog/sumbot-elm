module Model exposing (..)

{-
   Pulls together all child components into top level models and init.
-}

import Global.Model as Global
import TransactionList.Model as TransactionList


-- MODEL


type alias Model =
    { global : Global.Model
    , transactionList : TransactionList.Model
    }



-- INIT


type alias Flags =
    {}


init : Flags -> ( Model, Cmd msg )
init flags =
    ( initialModel flags, Cmd.none )


initialModel : Flags -> Model
initialModel flags =
    { global = Global.initialModel
    , transactionList = TransactionList.initialModel
    }
