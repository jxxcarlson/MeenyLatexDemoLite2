module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Keyed as Keyed
import Json.Encode
import MeenyLatex.Differ exposing (EditRecord)
import MeenyLatex.Driver


main =
    Browser.element { view = view, update = update, init = init, subscriptions = subscriptions }


-- TYPES

type alias Model a =
    { sourceText : String
    , renderedText : a
    }

type Msg
    = Clear
    | Render
    | TextA
    | TextB
    | TextC
    | GetContent String


type alias Flags =
    {}

render : String -> Html msg 
render sourceText =
  let 
    macroDefinitions = ""
  in 
    MeenyLatex.Driver.render macroDefinitions sourceText

-- MAIN FUNCTIONS

init : Flags -> ( Model (Html msg), Cmd Msg )
init flags =
    let
        model =
            { sourceText = textA
            , renderedText = render textA
            }
    
    in
    ( model, Cmd.none )


subscriptions : Model (Html msg) -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model (Html msg) -> ( Model (Html msg), Cmd Msg )
update msg model =
    case msg of
        Render ->
            ( { model
                | renderedText = render model.sourceText
              }
            , Cmd.none
            )

        Clear ->
            ({ model | sourceText = ""
              , renderedText = render ""
            }, Cmd.none)

        TextA ->
           ({ model | sourceText = textA
              , renderedText = render textA
            }, Cmd.none)

        TextB ->
           ({ model | sourceText = textB
              , renderedText = render textB
            }, Cmd.none)

        TextC ->
           ({ model | sourceText = textC
              , renderedText = render textC
            }, Cmd.none)


        GetContent str ->
            ( { model | sourceText = str }, Cmd.none )


-- VIEW FUNCTIONS 


view model =
    div [style "margin-top" "20px"]
        [ 
         label "Enter text or press a button :"
        , editor model
        , spacer 30
        , span [style "margin-left" "20px"] [ 
              button ([ onClick Clear ] ++ buttonStyle) [ text "Clear" ]
            , button ([ onClick Render ] ++ buttonStyle) [ text "Render" ]
            , button ([ onClick TextA ] ++ buttonStyle) [ text "Text A" ]
            , button ([ onClick TextB ] ++ buttonStyle) [ text "Text B" ]
            , button ([ onClick TextC ] ++ buttonStyle) [ text "Text C" ]
           
        ]
        , renderedSourcePane model
        ]


spacer n =
    div [ style "height" (String.fromInt n ++ "px") ] []


label text_ =
    p labelStyle [ text text_ ]

editor model =
   textarea (myTextStyle "#eef" ++ [ onInput GetContent, value model.sourceText ] ) 
      [  ]


renderedSourcePane : Model (Html msg) -> Html msg
renderedSourcePane model =
        -- |> List.map (\x -> Html.div [ style "margin-bottom" "0.65em" ] [ x ])
        Html.div renderedTextStyle [model.renderedText]



-- STYLE FUNCTIONS


renderedTextStyle = [
    style "width" "400px",
    style "height" "250px",
    style "margin-left" "20px", 
    style "margin-top" "7px",
    style "padding" "20px",
    style "background-color" "#eef7ee",
    style "overflow" "scroll"]

buttonStyle : List (Html.Attribute msg)
buttonStyle =
    [ style "backgroundColor" "rgb(100,100,100)"
    , style "color" "white"
    , style "width" "70px"
    , style "height" "25px"
    , style "margin-right" "10px"
    , style "font-size" "12pt"
    , style "text-align" "center"
    , style "border" "none"
    ]


labelStyle =
    [ style "margin-top" "5px"
    , style "margin-bottom" "0px"
    , style "margin-left" "20px"
    , style "font-style" "bold"
    ]


myTextStyle =
    textStyle "400px" "250px"


textStyle width height color =
    [ style "width" width
    , style "height" height
    , style "padding" "15px"
    , style "margin-left" "20px"
    , style "background-color" color
    , style "overflow" "scroll"
    ]


-- SOURCE TEXT

textA = 
  """
\\strong{Welcome!}
This is \\strong{Text A}.

\\smallskip

You should see formula
below this line.  

$$
\\int e^x dx = e^x + C
$$


\\smallskip

If not,
press \\strong{Text B}, 
then \\strong{Text A}.


\\smallskip
There seems to be an initialization
problem. \\italic{\\strong{Conjecture:} in the init
phase, the  DOM
does not yet have its math nodes set up
when the custom element code is called
to process math text.  But who knows?}

\\smallskip
\\strong{Notes.} 
This demo app uses
an experimental version of MiniLatex.
There are obvious deficiencies which
will be corrected soon.
"""



textB = 
    """
$$
\\frac{d}{dx} e^{kx} = ke^{kx}
$$
"""

textC =
    """
\\section{Introduction}

This \\strong{is} a test.  Here is the
Pythagorean Theorem: $a^2 + b^2 = c^2$.


You learned about \\eqref{integral}
in Calculus class.

\\begin{equation}
\\label{integral}
\\int_0^1 x^n dx = \\frac{1}{n+1}
\\end{equation}

\\subsection{More stuff}

\\begin{theorem}
There are infinitely many prime numbers
$p \\equiv 1\\ mod\\ 4$.
\\end{theorem}



\\subsection{Still more stuff}

\\begin{verbatim}
  # Code:

  sum = 0
  for i in range(1..101):
    sum = sum + 1.0/i
  sum
\\end{verbatim}

See also \\href{https://jxxcarlson.github.io/app/minilatex/src/index.html}{jxxcarlson.github.io}.


"""
