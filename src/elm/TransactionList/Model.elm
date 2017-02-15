module TransactionList.Model exposing (..)

import Global.Model exposing (Account, Category)
import Date exposing (..)


-- MODELS


type CategoryFilter
    = SingleCategory Category
    | NoCategory


type alias Model =
    { searchText : String
    , selectedCategories : List CategoryFilter
    , selectedAccount : Maybe Account
    , fromDate : Maybe Date
    , toDate : Maybe Date
    , pageSize : Int
    , pageNum : Int
    }



-- INIT


initialModel : Model
initialModel =
    { searchText = ""
    , selectedAccount = Nothing
    , selectedCategories = []
    , fromDate = Nothing
    , toDate = Nothing
    , pageSize = 100
    , pageNum = 1
    }
