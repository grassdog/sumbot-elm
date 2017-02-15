module TransactionList.Components.TransactionTable exposing (..)

import Model as Main
import Msg as Main exposing (..)
import Global.Model exposing (Account, Transaction, Category)
import TransactionList.Model exposing (Model)
import TransactionList.Msg exposing (..)
import TransactionList.Update exposing (filteredTransactions, currentPageOfTransactions, groupTransactionsByDate)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Color.Convert exposing (hexToColor)
import Utils.NumberFormat exposing (prettyInt)


transactionTable : Main.Model -> Html Main.Msg
transactionTable mainModel =
    let
        transactions =
            filteredTransactions mainModel.transactionList mainModel.global

        transactionPage =
            currentPageOfTransactions mainModel.transactionList transactions
    in
        div []
            [ table [ class "table table-striped" ] <| tableBody mainModel transactionPage
            , pagination mainModel.transactionList <| List.length transactions
            ]



-- HELPERS


tableBody : Main.Model -> List Transaction -> List (Html Main.Msg)
tableBody mainModel transactions =
    let
        totalCents =
            List.sum <| List.map .amountCents transactions

        groupedTransactions =
            groupTransactionsByDate transactions

        lastPage =
            ceiling <| (toFloat <| List.length transactions) / toFloat mainModel.transactionList.pageSize
    in
        [ thead []
            [ tr []
                [ th [] [ text "Description" ]
                , th [] [ text "Category" ]
                , th [] [ text "Amount" ]
                ]
            ]
        , tbody [] <| List.concatMap transactionsForDay <| groupedTransactions
        , tfoot []
            [ tr [ class "total" ]
                [ td [ colspan 2 ] [ text "Total" ]
                , td [] [ amountInDollars totalCents ]
                ]
            ]
        ]


transactionsForDay : ( String, List Transaction ) -> List (Html Main.Msg)
transactionsForDay ( date, ts ) =
    [ dateRow date ]
        ++ List.map transactionRow ts


dateRow : String -> Html Main.Msg
dateRow date =
    tr [ class "date-header" ]
        [ td [ colspan 3 ] [ text date ] ]


transactionRow : Transaction -> Html Main.Msg
transactionRow transaction =
    tr []
        [ td [] [ descriptionField transaction ]
        , td [] [ categoryField transaction.category ]
        , td [] [ amountInDollars transaction.amountCents ]
        ]


descriptionField : Transaction -> Html Main.Msg
descriptionField transaction =
    let
        description =
            Maybe.withDefault "" transaction.description

        notes =
            Maybe.withDefault "" <| Maybe.map (\t -> " · " ++ t) transaction.notes
    in
        div []
            [ p [] [ text description ]
            , p [ class "meta" ]
                [ span [] [ text transaction.account.name ]
                , span [ class "notes" ] [ text notes ]
                ]
            ]


categoryField : Maybe Category -> Html Main.Msg
categoryField c =
    let
        nullCategory =
            { id = -1
            , name = "(None)"
            , colour = Nothing
            , monthlyBudgetInCents = Nothing
            , analyseByDefault = False
            , proratedBudget = False
            }

        category : Category
        category =
            Maybe.withDefault nullCategory c

        colourStr =
            Maybe.withDefault "#efefef" <| Maybe.map (\c -> Color.Convert.colorToHex c) category.colour
    in
        td [ style [ ( "background-color", colourStr ) ] ] [ text <| category.name ]


amountInDollars : Int -> Html Main.Msg
amountInDollars amountInCents =
    let
        ( prefix, className ) =
            if amountInCents < 0 then
                ( "-$", "negative" )
            else
                ( "$", "positive" )

        dollars =
            round <| (toFloat amountInCents) / 100
    in
        div [ class className ]
            [ span [] [ text prefix ]
            , span [] [ text <| prettyInt ',' <| abs dollars ]
            ]


pagination : Model -> Int -> Html Main.Msg
pagination model transactionCount =
    let
        pageCount =
            ceiling <| (toFloat <| transactionCount) / toFloat model.pageSize

        offsetStart =
            (model.pageNum - 1) * model.pageSize

        offsetEnd =
            if pageCount == model.pageNum && transactionCount < offsetStart + model.pageSize then
                transactionCount
            else
                offsetStart + model.pageSize

        pageLink num =
            li
                [ class <|
                    if num == model.pageNum then
                        "active"
                    else
                        ""
                ]
                [ a
                    [ href "#"
                    , onClick <| MsgForTransactionList <| SetPage num
                    ]
                    [ text <| toString num ]
                ]
    in
        div []
            [ p []
                [ text <| "Transactions " ++ toString offsetStart ++ " – " ++ toString offsetEnd ]
            , nav []
                [ ul [ class "pagination" ] <| List.map pageLink (List.range 1 pageCount) ]
            ]
