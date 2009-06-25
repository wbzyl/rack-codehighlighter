# Rack::Codehighlighter middleware


## What?

The *rack-codehighlighter* gem provides a thin wrapper over 
a bunch of code highlighters to make their usage as generic possible:

* ultraviolet
* coderay
* syntax
* prettify
* censor (a fake highlighter used in the example below)


## How it works?

*Rack::Codehighlighter* looks for code blocks to be highlighted in the HTML
produced by your application. For each block found it calls requested
highlighter.


## Installing and Usage

Install the gem with:

    sudo gem install wbzyl-rack-codehighlighter -s http://gems.github.com

### Using *rack-codehighlighter* with a Rails application

In order to use, include the following code in a Rails application
`config/environment.rb` file:

    require 'coderay'               # get one of supported highlighters 
    require 'rack/codehighlighter'
    
    Rails::Initializer.run do |config|  
      config.gem 'coderay'
      config.gem 'wbzyl-rack-codehighlighter'
        
      config.middleware.use Rack::Codehighlighter, :coderay
    end  

### Using *rack-codehighlighter* with a Rack application

The *rack-codehighlighter* gem can be used with any Rack application,
for example with a **Sinatra** application. If your application
includes a rackup file or uses *Rack::Builder* to construct the
application pipeline, simply require and use as follows:

    gem 'coderay'       # get one of supported highlighters 
    require 'coderay'   
           
    gem 'wbzyl-rack-codehighlighter'
    require 'rack/codehighlighter'
     
    use Rack::Codehighlighter, :coderay
    run app


## *Rack::Codehighlighter* by an example

Below we ask *Rack::Codehighlighter* to look for code blocks into all
`pre` *element*s:

    use Rack::Codehighlighter, :coderay, :element => "pre", :pattern => /\A:::(\w+)\s*\n/

and use the `/\A:::(\w+)\s*\n/` *pattern* to learn what language 
the code block contains. 

For example:

    <pre>:::ruby
    puts "hello world"
    </pre>

Informal description of the *pattern*: if the element contents begins
with three colons, the text following the colons, up to the end of
line, identifies the language.
Language names are taken from the *ultraviolet* gem,
see bellow for the list.

Next, the text matched by the pattern is removed from the code block,
the matched element is removed, and code block is passed to *coderay*
highlighter for processing. 

Finally, the highlighted code returned by the *coderay* highlighter is
wrapped with `pre` element with attributes appropriate for the
codehighlighter used.

### More examples

In examples displayed below, the default value of each option is used.

Coderay:

    use Rack::Codehighlighter, :coderay,
      :element => "pre", :pattern => /\A:::(\w+)\s*\n/, :logging => false

Ultraviolet:

    use Rack::Codehighlighter, :ultraviolet, :theme => "dawn", :lines => false,
      :element => "pre", :pattern => /\A:::(\w+)\s*\n/, :logging => false

Prettify:

    use Rack::Codehighlighter, :prettify,
      :element => "pre", :pattern => /\A:::(\w+)\s*\n/, :logging => false

Syntax:

    use Rack::Codehighlighter, :syntax,
      :element => "pre", :pattern => /\A:::(\w+)\s*\n/, :logging => false

Censor:

    use Rack::Codehighlighter, :censor, :reason => "[[--  ugly code removed  --]]",
      :element => "pre", :pattern => /\A:::(\w+)\s*\n/, :logging => false


In Markdown, Maruku and RDiscount templates, code is wrapped with `pre>code`.
To remove extra one level of nesting the `:markdown` option should be used:

    use Rack::Codehighlighter, :coderay, :markdown => true,
      :element => "pre>code", :pattern => /\A:::(\w+)\s*\n/, :logging => false

Check the `examples` directory for working examples.

## Try it!

Simple Copy & Paste example. Implemented in Sinatra and uses inline template.

    # example.rb

    require 'rubygems'
    gem 'sinatra', '>=0.9.0' 
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

The results are accessible from `http://localhost:4567`.


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


## Why? TODO

Currently, almost everything what I write is rendered by Ruby on Rails
and Sinatra applications. To improve the readability of the text, I
want the code fragments to be colored. So extending Rails and Sinatra
frameworks with syntax highlighting is a must.

The problem is to how syntax highlighting features are hooked into
these frameworks.

Look at the current practice. To this end, analyze the top three tools
listed on *The Ruby Toolbox* in category 
[Syntax Highlighting](http://ruby-toolbox.com/categories/syntax_highlighting.html).

[tm_syntax_highlighting](http://github.com/arya/tm_syntax_highlighting/) (plugin):

    code(some_ruby_code, :theme => "twilight", :lang => "ruby", :line_numbers => true)

[harsh](http://carboni.ca/projects/harsh/) (plugin):

    <% harsh :theme => :dawn do %>    |    <% harsh %Q{ some_ruby_code }, :theme => :dawn %>
      some_ruby_code                  |
    <% end %>                         |

[Redcloth with CodeRay](http://github.com/augustl/redcloth-with-coderay) (gem):

    <source:ruby> some_ruby_code </source> 

Overdone: highlighting engine/library/framework.
Different solutions for each one framework are needed.
Different output: include.

With Rack based application we can simplifiy thingst by adding to the
application pipeline..

[*Ruby tips from me, your idol*](http://www.binarylogic.com/2009/04/19/ruby-tips-from-me-your-idol):
I can not tell you how much time I’ve wasted trying to add in some
cool feature into rails. I would dig into the rails internals,
override methods, do all kinds of tricky stuff. I thought I was
awesome. A month later rails comes out with some cool new feature, I
update rails and everything explodes.

Conclusion: highlighting via plugins is doomed to explode sooner or later.


*Rack::Codehighlighter* provides a thin wrapper over 
a bunch of code highlighters to make their usage as generic possible.

Uniform/define own..

In each piece of code inserted into html we must change:
`<` to `&lt;`. This is annoying thing.
Each(? prettify, dp-) pure javascript highlighter has this defect.

In pre-Rack applications era possible approaches were:

* gems;  connection to methods responsible for code highlighting
  is obtrusive, i.e. via plugin + additional markup

Analyze packages mentioned at the *The Ruby Toolbox* page:
[Syntax Highlighting](http://ruby-toolbox.com/categories/syntax_highlighting.html)
