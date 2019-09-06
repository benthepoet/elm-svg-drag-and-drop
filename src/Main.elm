module Main exposing (..)

import Browser
import Html exposing (Html)
import Html.Attributes
import Svg exposing (Svg)
import Svg.Attributes 


type alias Circle =
    { cx : Int
    , cy : Int
    , r : Int
    }

type alias Flags =
    { width: Int
    , height: Int
    }

type alias Model = 
    { drag : Maybe ( Int, Int )
    , circle : Circle
    , width: Int
    , height: Int
    }

type Msg = NoOp


init : Flags -> ( Model, Cmd Msg )
init { width, height } = 
    let
        model =
            { drag = Nothing
            , circle = Circle ( width // 2 ) ( height // 2 ) ( width // 10 )
            , width = width
            , height = height
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
        [ Html.Attributes.class "flex"] 
        [ Html.div [] []
        , Html.div 
            [ Html.Attributes.class "text-center"]
            [ Svg.svg
                [ Svg.Attributes.width <| String.fromInt model.width
                , Svg.Attributes.height <| String.fromInt model.height
                ]
                [ Svg.circle
                    [ Svg.Attributes.fill "yellow"
                    , Svg.Attributes.stroke "green"
                    , Svg.Attributes.strokeWidth "4"
                    , Svg.Attributes.cx <| String.fromInt model.circle.cx
                    , Svg.Attributes.cy <| String.fromInt model.circle.cy
                    , Svg.Attributes.r <| String.fromInt model.circle.r ]
                    []
                ]
            ]
        , Html.div [] []
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