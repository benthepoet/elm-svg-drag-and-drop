module Main exposing (..)

import Browser
import Html exposing (Html)
import Html.Attributes
import Json.Decode
import Svg exposing (Svg)
import Svg.Attributes 
import Svg.Events

type alias Circle =
    { cx : Int
    , cy : Int
    , r : Int
    }

type alias Coordinate =
    { x: Int
    , y: Int
    }

type alias Flags =
    { width: Int
    , height: Int
    }

type alias Model = 
    { cursor : Maybe Coordinate
    , circle : Circle
    , width: Int
    , height: Int
    }

type Msg 
    = MouseDown Coordinate
    | MouseUp


coordinateDecoder : Json.Decode.Decoder Coordinate
coordinateDecoder =
    Json.Decode.map2 Coordinate
        (Json.Decode.field "clientX" Json.Decode.int)
        (Json.Decode.field "clientY" Json.Decode.int)


onMouseDown : ( Coordinate -> Msg ) -> Svg.Attribute Msg
onMouseDown tagger =
    Svg.Events.on "mousedown" 
        <| Json.Decode.map tagger coordinateDecoder  


onMouseUp : Msg -> Svg.Attribute Msg 
onMouseUp = 
    Svg.Events.onMouseUp


init : Flags -> ( Model, Cmd Msg )
init { width, height } = 
    let
        model =
            { cursor = Nothing
            , circle = Circle ( width // 2 ) ( height // 2 ) ( width // 10 )
            , width = width
            , height = height
            }
    in
    ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseDown coordinate ->
            ( { model | cursor = Just coordinate }
            , Cmd.none
            )

        MouseUp ->
            ( { model | cursor = Nothing }
            , Cmd.none
            )


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
                , case model.cursor of
                    Nothing ->
                        Html.Attributes.attribute "data-inactive" "true"

                    Just _ ->
                        onMouseUp MouseUp
                ]
                [ Svg.circle
                    [ Svg.Attributes.fill "yellow"
                    , Svg.Attributes.stroke "green"
                    , Svg.Attributes.strokeWidth "4"
                    , Svg.Attributes.cx <| String.fromInt model.circle.cx
                    , Svg.Attributes.cy <| String.fromInt model.circle.cy
                    , Svg.Attributes.r <| String.fromInt model.circle.r
                    , onMouseDown MouseDown
                    ]
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