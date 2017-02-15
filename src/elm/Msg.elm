module Msg exposing (..)

import Global.Msg as Global
import TransactionList.Msg as TransactionList


type Msg
    = NoOp
    | MsgForGlobal Global.Msg
    | MsgForTransactionList TransactionList.Msg
