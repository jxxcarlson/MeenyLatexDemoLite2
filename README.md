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
MeenyLatexDemoLite`` -- console.log
statements were put in `index.html` to try to 
understand why math text is not displayed on startup.

I believe it is a timing problem: The calls
in custom element code occur before the 
content in the dom is available.  However,
(1) I don't know enough to know if this is 
true; (2) I don't know how to fix the problem.

```
STARTUP

connectedCallback index.html:112:3 
enqueueTypeset index.html:71:2 
connectedCallback index.html:112:3 
enqueueTypeset index.html:71:2 
connectedCallback index.html:112:3 
enqueueTypeset

============

CLICK TAB “Alt Text”

set content index.html:102:3 
connectedCallback index.html:112:3 
enqueueTypeset

=====

CLICK TAB “Orig Text”

set content index.html:102:3 
connectedCallback index.html:112:3 
enqueueTypeset index.html:71:2 
set content index.html:102:3 
connectedCallback index.html:112:3 
enqueueTypeset index.html:71:2 
set content index.html:102:3 
connectedCallback index.html:112:3 
enqueueTypeset index.html:71:2 
set content index.html:102:3 
connectedCallback index.html:112:3 
enqueueTypeset
```