module TransactionList.Update exposing (..)

import Model as Main
import Msg as Main exposing (..)
import Global.Model as Global exposing (Account, Transaction)
import TransactionList.Model exposing (..)
import TransactionList.Msg as TransactionList exposing (..)
import Regex exposing (..)
import Array exposing (fromList, get)
import String exposing (toInt)
import Date exposing (fromString, Date)
import Date.Extra exposing (compare)
import List.Extra as List
import Dict exposing (Dict)
import Dict.Extra as Dict


update : Main.Msg -> Main.Model -> Model
update msgFor mainModel =
    case msgFor of
        MsgForTransactionList msg ->
            updateTransactionList msg mainModel

        _ ->
            mainModel.transactionList


updateTransactionList : TransactionList.Msg -> Main.Model -> Model
updateTransactionList msg mainModel =
    let
        transactionList =
            mainModel.transactionList
    in
        case msg of
            ChangeSearchText newSearchText ->
                { transactionList | searchText = newSearchText }

            SetAccount newAccountIndex ->
                { transactionList | selectedAccount = (lookupSelectedAccount mainModel.global newAccountIndex) }

            SetCategories newCategories ->
                { transactionList | selectedCategories = (lookupSelectedCategories mainModel.global newCategories) }

            SetFromDate date ->
                { transactionList | fromDate = (parseDate date) }

            SetToDate date ->
                { transactionList | toDate = (parseDate date) }

            SetUncategorised ->
                { transactionList | selectedCategories = [ NoCategory ] }

            ClearAll ->
                initialModel

            SetPage newPage ->
                { transactionList | pageNum = newPage }



-- HELPERS


parseDate : String -> Maybe Date
parseDate dateStr =
    case fromString dateStr of
        Ok date ->
            Just date

        Err _ ->
            Nothing


lookupSelectedAccount : Global.Model -> Int -> Maybe Account
lookupSelectedAccount model newAccountIndex =
    if newAccountIndex == 0 then
        Nothing
    else
        Array.fromList model.accounts |> Array.get (newAccountIndex - 1)


lookupSelectedCategories : Global.Model -> List String -> List CategoryFilter
lookupSelectedCategories model categoryIds =
    let
        buildCategoryFilter id =
            case String.toInt id of
                Ok idInt ->
                    if idInt == -1 then
                        Just NoCategory
                    else
                        case List.find (\c -> c.id == idInt) model.categories of
                            Just c ->
                                Just (SingleCategory c)

                            Nothing ->
                                Nothing

                Err _ ->
                    Nothing
    in
        List.filterMap buildCategoryFilter categoryIds



-- VIEW HELPERS


filteredTransactions : Model -> Global.Model -> List Transaction
filteredTransactions model globalModel =
    let
        textRegex =
            Regex.caseInsensitive <| Regex.regex <| ".*" ++ model.searchText ++ ".*"

        filterText transaction =
            (Regex.contains textRegex <| (Maybe.withDefault "" transaction.description))
                || (Regex.contains textRegex <| (Maybe.withDefault "" transaction.notes))

        filterAccount transaction =
            case model.selectedAccount of
                Just account ->
                    transaction.account == account

                Nothing ->
                    True

        filterCategory : Transaction -> CategoryFilter -> Bool
        filterCategory transaction categoryFilter =
            case transaction.category of
                Just cat ->
                    case categoryFilter of
                        SingleCategory cf ->
                            cf == cat

                        NoCategory ->
                            False

                Nothing ->
                    case categoryFilter of
                        SingleCategory _ ->
                            False

                        NoCategory ->
                            True

        filterCategories transaction =
            if List.isEmpty model.selectedCategories then
                True
            else
                List.any (filterCategory transaction) model.selectedCategories

        filterFromDate transaction =
            case model.fromDate of
                Just fromDate ->
                    Date.Extra.compare fromDate transaction.date /= GT

                Nothing ->
                    True

        filterToDate transaction =
            case model.toDate of
                Just toDate ->
                    Date.Extra.compare toDate transaction.date /= LT

                Nothing ->
                    True

        filterTransaction transaction =
            filterText transaction
                && filterAccount transaction
                && filterCategories transaction
                && filterFromDate transaction
                && filterToDate transaction

        sortedTransactions =
            List.sortWith (\t1 t2 -> Date.Extra.compare t2.date t1.date) globalModel.transactions
    in
        List.filter filterTransaction sortedTransactions


uncategorisedTransactionCount : Global.Model -> Int
uncategorisedTransactionCount globalModel =
    let
        uncategorisedTransaction transaction =
            case transaction.category of
                Just cat ->
                    False

                Nothing ->
                    True
    in
        List.length <| List.filter uncategorisedTransaction globalModel.transactions


currentPageOfTransactions : Model -> List Transaction -> List Transaction
currentPageOfTransactions model transactions =
    let
        offset =
            (model.pageNum - 1) * model.pageSize
    in
        List.take model.pageSize <| List.drop offset transactions


groupTransactionsByDate : List Transaction -> List ( String, List Transaction )
groupTransactionsByDate transactions =
    let
        dateDict =
            Dict.groupBy (\t -> ( Date.Extra.toFormattedString "yyyy-MM-dd" t.date, Date.Extra.toFormattedString "EEE, dd MMM yyyy" t.date )) transactions

        transformResult ( ( _, date ), ts ) =
            ( date, ts )
    in
        List.reverse <| List.map transformResult <| Dict.toList <| dateDict
