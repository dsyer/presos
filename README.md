Presentations for conferences and user groups etc. Source code is in a
mixture of Markdown and [Asciidoctor](http://asciidoctor.org), and is
best viewed for presentation using
[deck.js](https://github.com/imakewebthings/deck.js) and
[asciidoctor-backends](https://github.com/asciidoctor/asciidoctor-backends). Local
deck.js themes are provided in the `/themes` directory. The deck.js
and asciidoctor templates are provided as a submodules.

## Github Co-ordinates

The slides sources are all in github at
[https://github.com/dsyer/presos](https://github.com/dsyer/presos). Clone
them (read only) like this:

    $ git clone https://github.com/dsyer/presos
    $ git submodule update --init

## Building the Site

Use Ruby 1.9.3 and make sure you have `bundle` on your `PATH` 

    $ cd presos
    $ bundle 
    $ bundle exec jekyll build
    ...
    
This builds all slides and puts them in `_site`. 

If you run `guard` instead of `jekyll` it also rebuilds each deck as
you reload it. You can also use `jekyll serve -w` to run a server on
port 4000 that rebuilds the site on changes (I prefer to use `guard`
because I can browse the files using a `file:...` URL).

## Static Website

The decks are all in `gh-pages` at
[http://presos.dsyer.com](http://presos.dsyer.com).
