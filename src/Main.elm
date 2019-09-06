module Main exposing (..)

import Browser
import Html exposing (Html)
import Svg exposing (Svg)
import Svg.Attributes 


type alias Model = 
    { drag : Maybe ( Int, Int, Int )
    , circle : ( Int, Int )
    , size : ( Int, Int )
    }

type Msg = NoOp


firstString =
    Tuple.first >> String.fromInt


secondString =
    Tuple.second >> String.fromInt


init : () -> ( Model, Cmd Msg )
init _ = 
    let
        model =
            { drag = Nothing
            , circle = ( 320, 240 )
            , size = ( 640, 480 )  
            }
    in
    ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none ) 


view : Model -> Html Msg
view model =
    Html.div 
        [] 
        [ Svg.svg
            [ Svg.Attributes.width <| String.fromInt <| Tuple.first model.size
            , Svg.Attributes.height <| String.fromInt <| Tuple.second model.size
            ]
            [ Svg.circle
                [ Svg.Attributes.fill "yellow"
                , Svg.Attributes.stroke "green"
                , Svg.Attributes.strokeWidth "4"
                , Svg.Attributes.cx <| firstString model.circle
                , Svg.Attributes.cy <| secondString model.circle
                , Svg.Attributes.r "50" ]
                []
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Browser.element
        { init = init 
        , update = update
        , view = view
        , subscriptions = subscriptions
        }