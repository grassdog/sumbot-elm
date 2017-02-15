module View exposing (..)

import Model exposing (Model)
import Msg exposing (Msg)
import TransactionList.View as TransactionListView
import Html exposing (..)
import Html.Attributes exposing (..)


rootView : Model -> Html Msg
rootView model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ h1 [] [ text "Sumbot!" ] ]
        , TransactionListView.view model
        ]
