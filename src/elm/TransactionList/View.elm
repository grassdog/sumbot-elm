module TransactionList.View exposing (view)

import Model as Main
import Msg as Main exposing (..)
import TransactionList.Components.TransactionTable as TransactionTable
import TransactionList.Components.FilterForm as FilterForm
import Html exposing (..)
import Html.Attributes exposing (..)


view : Main.Model -> Html Main.Msg
view mainModel =
    div [ class "row" ]
        [ div [ class "col-md-9" ]
            [ h3 [] [ text "Transactions" ]
            , TransactionTable.transactionTable mainModel
            ]
        , div [ class "col-md-3" ]
            [ h3 [] [ text "Filters" ]
            , FilterForm.filterForm mainModel
            ]
        ]
