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
if you press the "Alt Text" button, alternate text
is loaded, rendered, and correctly displayed.  The
same is true if you press the "Orig Text" button, 
which loads the original text which is loaded on 
startup.

Problem 2
---------

Runtime error when running as an Ellie.  See
https://ellie-test-19-cutover.now.sh/q96nCK64MRa1


Notes
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
editRecord = MeenyLatex.Driver.setup 0 textA
```

in initializing or updating the model. This code
is not very transparent

```
1. STARTUP
# init is called, and it calls
# editRecord = MeenyLatex.Driver.setup 0 textA
# in updating the model

connectedCallback
enqueueTypeset

// No math display 

============

2. CLICK TAB “Text B”:
# update is called, and it calls
# editRecord = MeenyLatex.Driver.setup 0 textB

set content
connectedCallback
enqueueTypeset

// Math display OK

=====

3. CLICK TAB “Text A”
# update is called, and it calls
# editRecord = MeenyLatex.Driver.setup 0 textA
# This is the same call as in (1)

set content
connectedCallback
enqueueTypeset

// Math display OK
```