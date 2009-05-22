# Rack Middleware for Code Highlighting

The *Codehighlighter* gem provides a thin interface over a bunch 
of exisitng code highlighters to make their usage as generic possible.

To install it, run:

    sudo gem install wbzyl-codehighlighter-middleware -s http://gems.github.com

Markup your code with:

    <pre><code>:::ruby
    ...
    </code></pre>

or in Markdown/RDiscount templates:

    :::ruby
    ...

Example (incomplete html, needs a layout file):

    # file simple.rb

    require 'rubygems'
    require 'sinatra'
    require 'rdiscount'
    require 'coderay'    # here we use the Coderay highlighter

    gem 'wbzyl-sinatra-rdiscount'
    require 'sinatra/rdiscount'

    gem 'wbzyl-sinatra-rdiscount'
    require 'wbzyl-codehighlighter-middleware'
    
    use Rack::Codehighlighter, :coderay
    
    get "/" do
      rdiscount :hello
    end
    
    __END__
    
    @@ hello
    ### Fibonacci numbers in Ruby
    
        :::ruby
        def fib(n)
          if n < 2
            1
          else
            fib(n-2) + fib(n-1)
          end
        end

Instal the gem with:

    rake install


## An example

The Codehighlighter follows the same syntax as regular Markdown
code blocks, with one exception. It needs to know what
language to use for the code block.

If the first line begins with three colons, the text following
the colons identifies the language (ruby in the example). 
The first line is removed from the code block before processing.

Run the above example with:

    ruby simple.rb

The directory *examples* contains ready to run, simple Sinatra app. Try

    rackup -p 4567 config.ru

or better yet (requires the *thin* gem to be installed):

    thin --rackup config.ru -p 4567 start


Finally, visit the following url:

    http://localhost:4567

and contemplate the sheer beauty of the rendered code.


## Supported Highlighters

These currently include: *Syntax*, *Coderay* (very fast), *Ultraviolet*.

### Syntax, fast

Supported languages: 

* xml
* ruby

I added support for these languages:

* ansic 
* javascript
* css21
* sqlite


### [Coderay](http://coderay.rubychan.de/), very fast

Supported languages:

* C
* CSS
* Delphi
* diff
* HTML
* RHTML (Rails)
* Nitro-XHTML
* Java
* JavaScript
* JSON
* Ruby
* YAML

### [Google Code Prettify](http://code.google.com/p/google-code-prettify/), pure Javascript

Supported languages:

* css, lisp, hs, lua, sql, vb, wiki,
* bsh, c, cc, cpp, cs, csh, cyc, cv, htm, html,
* java, js, m, mxml, perl, pl, pm, py, rb, sh,
* xhtml, xml, xsl


### Ultraviolet, slow

Needs oniguruma regexp library.
Installation instruction for Oniguruma:
[Carbonica](http://carboni.ca/projects/harsh/)

Supported languages:

* actionscript
* active4d
* active4d\_html
* active4d\_ini
* active4d\_library
* ada
* antlr
* apache
* applescript
* asp
* asp\_vb.net
* bibtex
* blog\_html
* blog\_markdown
* blog\_text
* blog\_textile
* build
* bulletin\_board
* c
* c++
* cake
* camlp4
* cm
* coldfusion
* context\_free
* cs
* css
* css\_experimental
* csv
* d
* diff
* dokuwiki
* dot
* doxygen
* dylan
* eiffel
* erlang
* f-script
* fortran
* fxscript
* greasemonkey
* gri
* groovy
* gtd
* gtdalt
* haml
* haskell
* html
* html-asp
* html\_django
* html\_for\_asp.net
* html\_mason
* html\_rails
* html\_tcl
* icalendar
* inform
* ini
* installer\_distribution\_script
* io
* java
* javaproperties
* javascript
* javascript\_+\_prototype
* javascript\_+\_prototype\_bracketed
* jquery\_javascript
* json
* languagedefinition
* latex
* latex\_beamer
* latex\_log
* latex\_memoir
* lexflex
* lighttpd
* lilypond
* lisp
* literate\_haskell
* logo
* logtalk
* lua
* m
* macports\_portfile
* mail
* makefile
* man
* markdown
* mediawiki
* mel
* mips
* mod\_perl
* modula-3
* moinmoin
* mootools
* movable\_type
* multimarkdown
* objective-c
* objective-c++
* ocaml
* ocamllex
* ocamlyacc
* opengl
* pascal
* perl
* php
* plain\_text
* pmwiki
* postscript
* processing
* prolog
* property\_list
* python
* python\_django
* qmake\_project
* qt\_c++
* quake3\_config
* r
* r\_console
* ragel
* rd\_r\_documentation
* regexp
* regular\_expressions\_oniguruma
* regular\_expressions\_python
* release\_notes
* remind
* restructuredtext
* rez
* ruby
* ruby\_experimental
* ruby\_on\_rails
* s5
* scheme
* scilab
* setext
* shell-unix-generic
* slate
* smarty
* sql
* sql\_rails
* ssh-config
* standard\_ml
* strings\_file
* subversion\_commit\_message
* sweave
* swig
* tcl
* template\_toolkit
* tex
* tex\_math
* textile
* tsv
* twiki
* txt2tags
* vectorscript
* xhtml\_1.0
* xml
* xml\_strict
* xsl
* yaml
* yui\_javascript
