module TransactionList.Components.FilterForm exposing (..)

import Model as Main
import Msg as Main exposing (..)
import Global.Model exposing (Account, Transaction, Category)
import TransactionList.Model exposing (..)
import TransactionList.Msg as TransactionList exposing (..)
import TransactionList.Update exposing (uncategorisedTransactionCount)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Json exposing (Decoder, int, string, field)
import Html.Events exposing (onInput, on, targetValue, onClick)
import MultiSelect exposing (..)
import Date exposing (..)
import Date.Extra as Date

-- multiSelectOptions : MultiSelect.Options Msg
-- multiSelectOptions =
--     let
--         defaultOptions =
--             MultiSelect.defaultOptions MultiSelectChanged
--     in
--         { defaultOptions
--             | items =
--                 [ { value = "1", text = "One", enabled = True }
--                 , { value = "2", text = "Two", enabled = True }
--                 , { value = "3", text = "Three", enabled = True }
--                 , { value = "4", text = "Four", enabled = True }
--                 ]
--         }

filterForm : Main.Model -> Html Main.Msg
filterForm mainModel =
    div []
        [ buildUncategorisedButton mainModel
        , input
            [ placeholder "Search"
            , onInput (\s -> MsgForTransactionList <| ChangeSearchText s)
            , value mainModel.transactionList.searchText
            ]
            []
        , input
            [ placeholder "From"
            , type_ "date"
            , onInput (\s -> MsgForTransactionList <| SetFromDate s)
            , value <| dateString mainModel.transactionList.fromDate
            ]
            []
        , input
            [ placeholder "To"
            , type_ "date"
            , onInput (\s -> MsgForTransactionList <| SetToDate s)
            , value <| dateString mainModel.transactionList.toDate
            ]
            []
        -- MultiSelectChanged (List String)
        -- , multiSelect
        , select
            (onMultiSelect (\cs -> MsgForTransactionList <| SetCategories cs))
            ([ buildNoCategoryOption mainModel ] ++ (List.map (buildCategoryOption mainModel) mainModel.global.categories))
        , select
            (onSingleSelect (\a -> MsgForTransactionList <| SetAccount a))
            ([ option [ value "" ] [ text "(None)" ] ] ++ (List.map (buildAccountOption mainModel) mainModel.global.accounts))
        , button
            [ onClick (MsgForTransactionList ClearAll) ]
            [ text <| "Clear all" ]
        ]



-- HELPERS


dateString : Maybe Date -> String
dateString maybeDate =
    case maybeDate of
        Just date ->
            Date.toFormattedString "yyyy-MM-dd" date

        Nothing ->
            ""


buildUncategorisedButton : Main.Model -> Html Main.Msg
buildUncategorisedButton mainModel =
    let
        count =
            uncategorisedTransactionCount mainModel.global
    in
        button [ disabled <| count == 0, onClick (MsgForTransactionList SetUncategorised) ] [ text <| "Uncategorised (" ++ (toString count) ++ ")" ]


buildNoCategoryOption : Main.Model -> Html Main.Msg
buildNoCategoryOption mainModel =
    let
        isSelected =
            List.member NoCategory mainModel.transactionList.selectedCategories
    in
        option [ value "-1", selected isSelected ] [ text "(None)" ]


buildCategoryOption : Main.Model -> Category -> Html Main.Msg
buildCategoryOption mainModel category =
    let
        isSelected =
            List.member (SingleCategory category) mainModel.transactionList.selectedCategories
    in
        option [ value (toString category.id), selected isSelected ] [ text (toString category.name) ]


buildAccountOption : Main.Model -> Account -> Html Main.Msg
buildAccountOption mainModel account =
    option [ value (toString account.id), selected (isAccountOptionSelected mainModel.transactionList.selectedAccount account.id) ] [ text (toString account.name) ]


isAccountOptionSelected : Maybe Account -> Int -> Bool
isAccountOptionSelected account id =
    case account of
        Just m ->
            m.id == id

        Nothing ->
            False

targetSelectedOptions : Json.Decoder (List String)
targetSelectedOptions =
    let
        maybeValues =
            Json.at [ "target", "selectedOptions" ] <|
                Json.keyValuePairs <|
                    Json.maybe (Json.field "value" Json.string)

        extractValues mv =
            List.filterMap Tuple.second mv
    in
        Json.map extractValues maybeValues


onMultiSelect : (List String -> msg) -> List (Html.Attribute msg)
onMultiSelect msg =
    [ on "change" (Json.map msg targetSelectedOptions), multiple True ]


targetSelectedIndex : Json.Decoder Int
targetSelectedIndex =
    Json.at [ "target", "selectedIndex" ] Json.int


onSingleSelect : (Int -> msg) -> List (Html.Attribute msg)
onSingleSelect msg =
    [ on "change" (Json.map msg targetSelectedIndex) ]
