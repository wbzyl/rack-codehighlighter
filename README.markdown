# Rack::Codehighlighter middleware

*Rack::Codehighlighter* provides a thin wrapper over 
a bunch of code highlighters: 

* ultraviolet
* coderay
* syntax
* prettify

It reads HTML produced by an application where it looks for code blocks
to highlight. For example, below we ask *coderay* to highlight all `pre`
elements:

    use Rack::Codehighlighter, :coderay, :element => "pre", :pattern => /\A:::(\w+)\s*\n/

The middleware uses the `/\A:::(\w+)\s*\n/` pattern to
learn what language the code block contains. For example

    <pre>:::ruby
    puts "hello world"
    </pre>

The above example could be shortened to:

    use Rack::Codehighlighter, :coderay

because we used the default values for options.


## Why using middleware for code highlighting is awesome?

In pre-Rack applications era possible approaches were:

1. pure javascript; cons code must be html-escaped

2. gems;  conection to methods responsible for code highlighting
   is obtrusive, i.e. via plugin + additional markup

Analyze packages mentioned at the *The Ruby Toolbox* page:
[Syntax Highlighting](http://ruby-toolbox.com/categories/syntax_highlighting.html)

Links to sources

    http://carboni.ca/projects/harsh/  
      unless HAML is used
    http://redclothcoderay.rubyforge.org/  
    http://github.com/augustl/redcloth-with-coderay
      how to use with Rails
      does't degrade to html: new source tag
    http://github.com/arya/tm_syntax_highlighting/
      how to connect to rails/sinatra?

Add censored method/example.

[*Ruby tips from me, your idol*](http://www.binarylogic.com/2009/04/19/ruby-tips-from-me-your-idol):
I can not tell you how much time I’ve wasted trying to add in some
cool feature into rails. I would dig into the rails internals,
override methods, do all kinds of tricky stuff. I thought I was
awesome. A month later rails comes out with some cool new feature, I
update rails and everything explodes.

Conclusion: highlighting via plugins is doomed to explode sooner or later.


## Using with Rack application

First install the gem:

    sudo gem install wbzyl-rack-codehighlighter -s http://gems.github.com

*Rack::Codehighlighter* can be used with any Rack application, for example with
a **Sinatra** application. If your application includes a rackup file or
uses *Rack::Builder* to construct the application pipeline, simply
require and use as follows:

    gem 'wbzyl-rack-codehighlighter'
    require 'rack/codehighlighter'
    
    gem 'coderay'
    require 'coderay'
    
    use Rack::Codehighlighter, :coderay  # more options
    run app

Instead of *coderay* you can use other supported highlighters.
Remember to include in the layout one of provided stylesheets
(look into `examples/public/stylesheets` for sample stylesheets.

## Using with Rails

In order to use include the following in a Rails application
`config/environment.rb` file:

    require 'rack/codehighlighter'
    
    Rails::Initializer.run do |config|  
      config.gem 'wbzyl-rack-codehighlighter'
      config.middleware.use Rack::Codehighlighter, :ultraviolet
    end  

Check the Rack configuration:

    rake middleware

Remember to include in the layout one of provided stylesheets
(look into `examples/public/stylesheets` for sample stylesheets.


## Configuration options

Show one complete example for each supported hilighter.

## Quick Sinatra example

Sinatra example:

    # file example.rb

    require 'rubygems'
    require 'sinatra'

    gem 'wbzyl-rack-codehighlighter', '>=0.2.0'
    require 'rack/codehighlighter'
    
    use Rack::Codehighlighter, :censor, :reason => '[[--difficult code removed--]]'
    
    get "/" do
      erb :hello
    end
    
    __END__
    
    @@ hello
    <h3>Fibonacci numbers in Ruby</h3>
    
    <pre><code>:::ruby
    def fib(n)
      if n < 2
        1
      else
        fib(n-2) + fib(n-1)
      end
    end
    </code></pre>

Run the above example with:

    ruby example.rb


## More Sinatra examples

The default markup:

If the first line begins with three colons, the text following
the colons identifies the language (ruby in the example). 
The first line is removed from the code block before processing.

The directory *examples* contains ready to run, simple Sinatra app. Try

    rackup -p 4567 config.ru

or better yet (requires the *thin* gem to be installed):

    thin --rackup config.ru -p 4567 start


Finally, visit the following url:

    http://localhost:4567

and contemplate the sheer beauty of the rendered code.


## Supported Highlighters

These currently include: *Syntax* (fast), *Coderay* (very fast), 
*Ultraviolet* (slow, but highlights almost any language).

The *Codehighlighter* gem provides a thin interface over a bunch of
exisitng code highlighters to make their usage as generic possible.

What does it mean? Explain.


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

### [Google Code Prettify](http://code.google.com/p/google-code-prettify/), pure Javascript

Languages supported by *Prettify*:

* css, lisp, hs, lua, sql, vb, wiki,
* bsh, c, cc, cpp, cs, csh, cyc, cv, htm, html,
* java, js, m, mxml, perl, pl, pm, py, rb, sh,
* xhtml, xml, xsl

### [Ultraviolet](http://ultraviolet.rubyforge.org/)

The *ultraviolet* gem needs oniguruma regexp library.

On Fedora install the library with:

    sudo yum install oniguruma

For installation instruction from sources, see
[Carbonica](http://carboni.ca/projects/harsh/)

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
