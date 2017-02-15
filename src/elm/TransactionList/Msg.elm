module TransactionList.Msg exposing (..)


type Msg
    = ChangeSearchText String
    | SetAccount Int
    | SetFromDate String
    | SetToDate String
    | SetCategories (List String)
    | SetUncategorised
    | SetPage Int
    | ClearAll
