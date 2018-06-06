MeenyLatex MeenyDemo app
========================

Compile with

```
$ elm make Main.elm --output=Main.js
```

Run by clicking on `index.html`


Problem 1
---------

The math text is not displaying on startup. However,
if you press the "Text B" button, alternate text
is loaded, rendered, and correctly displayed.  Or 
if you subsequently press the "Text A" button to 
reload the original text.

Alternate test: click "Clear", type in your own
LaTeX text, then click "Render."

Problem 2
---------

Runtime error when running as an Ellie.  See
https://ellie-test-19-cutover.now.sh/rtpvjyYX5Ka1


NOTES
-----
Below is console output for a session with
MeenyLatexDemoLite -- console.log
statements were put in `index.html` to try to 
understand why math text is not displayed on startup.

I believe the problem has to do with timing/sequencing: 
Conjecturally, the calls to the custom element code occur before 
the content in the DOM is available.  However,
(1) I don't know enough to know if this is 
true; (2) I don't know how to fix the problem.

The call to the custom element code results 
from executing

```
renderedText = render theSourceText
```

in initializing or updating the model. This code
comes from the MeenyLatex package:

```
render : String -> Html msg 
render sourceText =
  let 
    macroDefinitions = ""
  in 
    MeenyLatex.Driver.render macroDefinitions sourceText
```

1. STARTUP
# init is called, and it calls
# Use renderedText = render textA
# to initialize model.renderedText

# CONSOLE OUTPUT
connectedCallback
enqueueTypeset

# No math display 

============

2. CLICK TAB “Text B”:
# Use renderedText = render textB
# to update model.renderedText

# CONSOLE OUTPUT
set content
connectedCallback
enqueueTypeset

# Math display OK

=====

3. CLICK TAB “Text A”
# Use renderedText = render textA
# to update model.renderedText
# This is the same call as in (1)

# CONSOLE OUTPUT
set content
connectedCallback
enqueueTypeset

# Math display OK
```