Presentations for conferences and user groups etc. Source code is in
Markdown, and is best viewed for presentation using
[deck.js](https://github.com/imakewebthings/deck.js) and
[markdown2deckjs](https://github.com/ulf/markdown2deckjs). Both
deck.js and markdown2deckjs have been patched to add themes etc, so
they are provided as submodules.

## Github Co-ordinates

The slides sources are all in github at
[https://github.com/dsyer/presos](https://github.com/dsyer/presos). Clone
them (read only) like this:

    $ git clone https://github.com/dsyer/presos

## Building the Site

Use Ruby 1.9.3 and make sure you have `bundle` on your `PATH` 

    $ cd presos
    $ bundle
    $ rackup
    ...
    
This builds all slides and then runs a server on port 3333 which
rebuilds each deck as you reload it.

## Static Website

The decks are all in `gh-pages` at
[dsyer.com/presos](http://dsyer.com/presos).
