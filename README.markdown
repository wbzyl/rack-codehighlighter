# Rack::Codehighlighter middleware

The *Rack::Codehighlighter* is a middleware which allows for easy
connecting a code highlighter of somebody's choice to an HTML page
containing pieces of programming code. Parameters to
*Rack::Codehighlighter* are: the name of a highlighter and a
specification of how to find the pieces of code in the page.

It supports the most popular Ruby code highlighters of today:

* ultraviolet
* coderay
* syntax

As well as

* [Unofficial Pygments API](http://pygments.appspot.com/)

To ease testing it implements *censor* highlighter.


## How it works?

*Rack::Codehighlighter* looks for code blocks to be highlighted in the HTML
produced by your application. For each block found it calls requested
highlighter.


## Installing and Usage

Install the gem with:

    sudo gem install rack-codehighlighter -s http://gemcutter.org

In order for the highlighting to show up, you’ll need to include a
highlighting stylesheet. For example stylesheets you can look at
stylesheets in the *examples/public/stylesheets* directory.

### Rails

In order to use, include the following code in a Rails application
*config/environment.rb* file:

    require 'coderay'               # get one of supported highlighters 
    require 'rack/codehighlighter'
    
    Rails::Initializer.run do |config|  
      config.gem 'coderay'
      config.gem 'rack-codehighlighter'
        
      config.middleware.use Rack::Codehighlighter, :coderay, :element => "pre", :pattern => /\A:::(\w+)\s*\n/
    end  

### Any Rack application

The *rack-codehighlighter* gem can be used with any Rack application,
for example with a **Sinatra** application. If your application
includes a rackup file or uses *Rack::Builder* to construct the
application pipeline, simply require and use as follows:

    gem 'coderay'       # get one of supported highlighters 
    require 'coderay'   
           
    gem 'rack-codehighlighter'
    require 'rack/codehighlighter'
     
    use Rack::Codehighlighter, :coderay, :element => "pre", :pattern => /\A:::(\w+)\s*\n/
    run app


## *Rack::Codehighlighter* by an example

To colorize code in *pre* elements with well known *coderay*
highlighter use the following:

    use Rack::Codehighlighter, :coderay, :element => "pre", :pattern => /\A:::(\w+)\s*\n/

The first parenthesized expression from the pattern `/\A:::(\w+)\s*\n/`
will be used to match the language name. For example, from the *pre*
element below:

    <pre>:::ruby
    puts "hello world"
    </pre>

the *ruby* name is extracted. 

To find the appropriate name to use for programming language,
look at the lists below.

Next, the matched element is removed and the second line is passed to
*coderay* highlighter for processing.

The highlighted code returned by the *coderay* highlighter is
wrapped with *pre* element with attributes appropriate for the
codehighlighter used.


### More examples

In examples displayed below, the default value of each option is used.

Coderay:

    use Rack::Codehighlighter, :coderay,
      :element => "pre", :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => false

Ultraviolet:

    use Rack::Codehighlighter, :ultraviolet, :theme => "dawn", :lines => false,
      :element => "pre", :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => false

or

    use Rack::Codehighlighter, :ultraviolet, :markdown => true, 
      :theme => "minimal_theme", :lines => false, :element => "pre>code", 
      :pattern => /\A:::([-_+\w]+)\s*(\n|&#x000A;)/, :logging => false,
      :themes => {"vibrant_ink" => ["ruby"], "upstream_sunburst" => ["objective-c", "java"]}

Unofficial Pygments API:

    use Rack::Codehighlighter, :pygments_api, :element => "pre",
       :pattern => /\A:::([-_+\w]+)\s*(\n|&#x000A;)/, :logging => false

Syntax:

    use Rack::Codehighlighter, :syntax,
      :element => "pre", :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => false

Censor:

    use Rack::Codehighlighter, :censor, :reason => "[[--  ugly code removed  --]]",
      :element => "pre", :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => false


Markdown, Maruku and RDiscount processors, the code is wrapped with `pre>code`.  
To remove this extra one level of nesting the `:markdown` option should be used:

    use Rack::Codehighlighter, :coderay, :markdown => true,
      :element => "pre>code", :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => false

**Remark:** Within `pre` tag, HAML replaces each new line characters
with the `&#x000A;` entity (line feed) so that it can ensure that it
doesn't adversely affect indentation.
This change confuses both rack-codehighlighter and the highlighters
themselves (e.g. Ultraviolet and Coderay).  So, to support `pre` tags
as rendered by HAML, `&#x000A;` was added to the default pattern.

Check the `examples` directory for working examples.


## Try it!

A simple Copy & Paste example.

    # example.rb

    require 'rubygems'
    gem 'sinatra'
    require 'sinatra'
    gem 'rack-codehighlighter'
    require 'rack/codehighlighter'
    
    use Rack::Codehighlighter, :censor, :reason => '[[--difficult code removed--]]'
    
    get "/" do
      erb :hello
    end
    
    __END__
    @@ hello
    <h3>Fibonacci numbers in Ruby</h3>
    <pre>:::ruby
    def fib(n)
      if n < 2
        1
      else
        fib(n-2) + fib(n-1)
      end
    end
    </pre>

Run the example with:

    ruby example.rb

and check results at *http://localhost:4567*.


## Supported highlighters

These currently include: *Syntax* (fast), *Coderay* (very fast), 
*Ultraviolet* (slow, but highlights almost any language).

### [Syntax](http://syntax.rubyforge.org/)

Languages supported by *Syntax*: 

* xml
* ruby

### [Coderay](http://coderay.rubychan.de/)

Languages supported by *Coderay*:

* C, CSS
* Delphi, diff
* HTML, RHTML (Rails), Nitro-XHTML
* Java, JavaScript, JSON
* Ruby
* YAML

### [Ultraviolet](http://ultraviolet.rubyforge.org/)

The *ultraviolet* gem needs oniguruma regexp library.

On Fedora install the library with:

    sudo yum install oniguruma oniguruma-devel

For installation instruction of the *oniguruma* library from sources,
see [Carbonica](http://carboni.ca/projects/harsh/)

Now, install the gem:

    sudo gem install ultraviolet

See also [Ultraviolet themes gallery](http://ultraviolet.rubyforge.org/themes.xhtml)

Ultraviolet supports almost any language:

* actionscript, active4d, active4d\_html, active4d\_ini, active4d\_library,
  ada, antlr, apache, applescript, asp, asp\_vb.net
* bibtex, blog\_html, blog\_markdown, blog\_text, blog\_textile, build,
  bulletin\_board
* c, c++, cake, camlp4, cm, coldusion, context\_free, cs, css, css\_experimental,
  csv
* d, diff, dokuwiki, dot, doxygen, dylan
* eiffel, erlang, f-script, fortran, fxscript
* greasemonkey, gri, groovy, gtd, gtdalt
* haml, haskell, html, html-asp, html\_django, html\_for\_asp.net, html\_mason,
  html\_rails, html\_tcl
* icalendar, inform, ini, installer\_distribution\_script, io
* java, javaproperties, javascript, javascript\_+\_prototype, 
  javascript\_+\_prototype\_bracketed, jquery\_javascript, json
* languagedefinition, latex, latex\_beamer, latex\_log, latex\_memoir, lexflex,
  lighttpd, lilypond, lisp, literate\_haskell, logo, logtalk, lua
* m, macports\_portfile, mail, makefile, man, markdown, mediawiki, mel,
  mips, mod\_perl, modula-3, moinmoin, mootools, movable\_type, multimarkdown
* objective-c, objective-c++, ocaml, ocamllex, ocamlyacc, opengl
* pascal, perl, php, plain\_text, pmwiki, postscript, processing,
  prolog, property\_list, python, python\_django
* qmake\_project, qt\_c++, quake3\_config
* r, r\_console, ragel, rd\_r\_documentation, regexp,
  regular\_expressions\_oniguruma, regular\_expressions\_python, release\_notes
  remind, restructuredtext, rez, ruby, ruby\_experimental, ruby\_on\_rails
* s5, scheme, scilab, setext, shell-unix-generic, slate, smarty,
  sql, sql\_rails, ssh-config, standard\_ml, strings\_file, subversion\_commit\_message,
  sweave, swig
* tcl, template\_toolkit, tex, tex\_math, textile, tsv, twiki, txt2tags
* vectorscript
* xhtml\_1.0, xml, xml\_strict, xsl
* yaml, yui\_javascript
