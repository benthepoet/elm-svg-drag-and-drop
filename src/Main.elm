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
    | MouseMove Coordinate
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


onMouseMove : ( Coordinate -> Msg ) -> Svg.Attribute Msg
onMouseMove tagger =
    Svg.Events.on "mousemove"
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

        MouseMove coordinate ->
            case model.cursor of
                Nothing ->
                    ( model, Cmd.none )

                Just previous ->
                    ( { model 
                        | cursor = Just coordinate
                        , circle = Circle 
                            ( model.circle.cx + coordinate.x - previous.x )
                            ( model.circle.cy + coordinate.y - previous.y )
                            ( model.circle.r )
                        }
                    , Cmd.none
                    )

        MouseUp ->
            ( { model | cursor = Nothing }
            , Cmd.none
            )


circleAttributes circle =
    [ Svg.Attributes.fill "yellow"
    , Svg.Attributes.stroke "green"
    , Svg.Attributes.strokeWidth "4"
    , Svg.Attributes.cx <| String.fromInt circle.cx
    , Svg.Attributes.cy <| String.fromInt circle.cy
    , Svg.Attributes.r <| String.fromInt circle.r
    , onMouseDown MouseDown
    ]


svgAttributes model =
    let
        attributes =
            [ Svg.Attributes.width <| String.fromInt model.width
            , Svg.Attributes.height <| String.fromInt model.height
            ]
    in
    case model.cursor of
        Nothing ->
            attributes

        Just _ ->
            onMouseMove MouseMove :: onMouseUp MouseUp :: attributes 


view : Model -> Html Msg
view model =
    Html.div
        []
        [ Html.nav 
            []
            [ Html.span
                [ Html.Attributes.class "brand" ]
                [ Html.text "Elm SVG Drag and Drop" ]
            , Html.div
                [ Html.Attributes.class "menu" ]
                [ Html.text <| 
                    String.join ", "
                        [ String.fromInt model.circle.cx 
                        , String.fromInt model.circle.cy
                        ]
                ]
            ]
        , Html.div 
            [ Html.Attributes.class "flex"] 
            [ Html.div [] []
            , Html.div 
                [ Html.Attributes.class "text-center"]
                [ Svg.svg
                    ( svgAttributes model )
                    [ Svg.circle
                        ( circleAttributes model.circle )
                        []
                    ]
                ]
            , Html.div [] []
            ]
        , Html.footer
            [ Html.Attributes.class "text-center" ]
            [ Html.text "Built by Ben Hanna | "
            , Html.a
                [ Html.Attributes.href "https://github.com/benthepoet/elm-svg-drag-and-drop" 
                , Html.Attributes.target "_blank"
                ]
                [ Html.text "View source on GitHub" ]
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