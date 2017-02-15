module Global.Model exposing (..)

{-
   Top level types and data shared across the entire application.
-}

import Color exposing (Color)
import Color.Convert exposing (hexToColor)
import Date exposing (..)
import Date.Extra as DE


-- MODEL


type alias Transaction =
    { id : Int
    , date : Date
    , amountCents : Int
    , description : Maybe String
    , notes : Maybe String
    , category : Maybe Category
    , account : Account
    }


type alias Category =
    { id : Int
    , name : String
    , colour : Maybe Color
    , monthlyBudgetInCents : Maybe Int
    , analyseByDefault : Bool
    , proratedBudget : Bool
    }


type alias Account =
    { id : Int
    , name : String
    }


type alias Model =
    { transactions : List Transaction
    , categories : List Category
    , accounts : List Account
    }



-- INIT


initialModel : Model
initialModel =
    let
        firstAccount =
            { id = 1
            , name = "Complete Access"
            }

        accounts : List Account
        accounts =
            [ { id = 3
              , name = "Cash"
              }
            , firstAccount
            ]

        categories : List Category
        categories =
            [ { id = 60
              , name = "Planned Spend"
              , colour = hexToColor "#FDECCB"
              , monthlyBudgetInCents = Nothing
              , analyseByDefault = True
              , proratedBudget = False
              }
            , { id = 9
              , name = "Shopping - Clothing"
              , colour = hexToColor "#f9a61c"
              , monthlyBudgetInCents = Just -13000
              , analyseByDefault = True
              , proratedBudget = False
              }
            , { id = 21
              , name = "Shopping - Gifts"
              , colour = hexToColor "#f9a61c"
              , monthlyBudgetInCents = Just -15000
              , analyseByDefault = True
              , proratedBudget = False
              }
            ]

        findCategory : Int -> Maybe Category
        findCategory id =
            List.head (List.filter (\c -> c.id == id) categories)
    in
        { accounts = accounts
        , categories = categories
        , transactions =
            [ { id = 7908
              , date = DE.fromParts 2016 Aug 29 0 0 0 0
              , amountCents = -6298
              , description = Just "AMEX WOOLWORTHS 4306 DOG SWAMPYOKINE 000"
              , notes = Just "An example note."
              , category = findCategory 9
              , account = firstAccount
              }
            , { id = 7895
              , date = DE.fromParts 2016 Aug 29 0 0 0 0
              , amountCents = -10000
              , description = Just "Wdl ATM CBA ATM DOG SWAMP S/C WA 614096 AUS"
              , notes = Nothing
              , category = findCategory 60
              , account = firstAccount
              }
            , { id = 7910
              , date = DE.fromParts 2016 Aug 28 0 0 0 0
              , amountCents = -5900
              , description = Just "HOBART DELI NORTH PERTH AUS"
              , notes = Nothing
              , category = findCategory 21
              , account = firstAccount
              }
            , { id = 7922
              , date = DE.fromParts 2016 Aug 28 0 0 0 0
              , amountCents = -3885
              , description = Just "SWAN TAXIS 13 13 30 VICTORIA PARWA"
              , notes = Nothing
              , category = findCategory 60
              , account = firstAccount
              }
            , { id = 7897
              , date = DE.fromParts 2016 Aug 27 0 0 0 0
              , amountCents = -2549
              , description = Just "AMEX WOOLWORTHS 4306 DOG SWAMPYOKINE 000"
              , notes = Nothing
              , category = findCategory 21
              , account = firstAccount
              }
            , { id = 7923
              , date = DE.fromParts 2016 Aug 26 0 0 0 0
              , amountCents = -1922
              , description = Just "SWAN TAXIS 13 13 30 VICTORIA PARWA"
              , notes = Nothing
              , category = findCategory 60
              , account = firstAccount
              }
            , { id = 7901
              , date = DE.fromParts 2016 Aug 26 0 0 0 0
              , amountCents = -7856
              , description = Just "SGIO SYDNEY NSW"
              , notes = Nothing
              , category = findCategory 9
              , account = firstAccount
              }
            , { id = 7898
              , date = DE.fromParts 2016 Aug 26 0 0 0 0
              , amountCents = -9504
              , description = Just "AMEX WOOLWORTHS 4306 DOG SWAMPYOKINE 000"
              , notes = Nothing
              , category = findCategory 22
              , account = firstAccount
              }
            , { id = 7886
              , date = DE.fromParts 2016 Aug 26 0 0 0 0
              , amountCents = -3400
              , description = Just "THE WILLIAM STREET B NORTHBRIDGE"
              , notes = Nothing
              , category = findCategory 13
              , account = firstAccount
              }
            , { id = 7884
              , date = DE.fromParts 2016 Aug 25 0 0 0 0
              , amountCents = -144350
              , description = Just "Loan Repayment LN REPAY 695082072"
              , notes = Nothing
              , category = findCategory 25
              , account = firstAccount
              }
            , { id = 7887
              , date = DE.fromParts 2016 Aug 25 0 0 0 0
              , amountCents = -9500
              , description = Just "AMEX TELSTRA EASYPAY DD2CC ADELAIDE 017"
              , notes = Nothing
              , category = findCategory 40
              , account = firstAccount
              }
            ]
        }
