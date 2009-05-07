# -*- coding: utf-8 -*-

require 'rack'
require 'hpricot'

module Rack
  class Codehighlighter
    def initialize(app, highlighter = :syntax, opts = {})
      @app = app
      @highlighter = highlighter
      @opts = opts
    end
    def call(env)
      status, headers, response = @app.call(env)
      if headers['Content-Type'] != nil && headers['Content-Type'].include?("text/html")
        content = ""
        response.each { |part| content += part }
        doc = Hpricot(content)
        nodes = doc.search("//pre/code")
        nodes.each do |node|
          s = node.inner_html || "[++where is the code?++]"
          node.parent.swap(send(@highlighter, s))
        end
        STDERR.puts "Highlighting code with: #{@highlighter}"
        body = doc.to_html
        size = body.respond_to?(:bytesize) ? body.bytesize : body.size
        headers['Content-Length'] = size.to_s
        [status, headers, [body]]
      else
        [status, headers, response]  
      end
    end
    
    private
    
    def syntax(string)
      translate = {
        'html' => 'xml',
        'c' => 'ansic',
        'css' => 'css21',
        'sql' => 'sqlite'
      }
      lang = "unknown"
      if /\A:::(\w+)\s*\n/ =~ string  # extract language name
        lang = $1
        convertor = ::Syntax::Convertors::HTML.for_syntax translate[lang]
        convertor.convert(unescape_html(string.sub(/\A.*\n/, "")) || "[=this can'n happen=]")
      else
        "<pre>#{string}</pre>"
      end
    end
    
    def coderay(string)
      lang = "unknown"
      if /\A:::(\w+)\s*\n/ =~ string  # extract language name
        lang = $1
        str = unescape_html(string.sub(/\A.*\n/, ""))
        "<pre class='CodeRay'>#{::CodeRay.encoder(:html).encode str, lang}</pre>"
      else
        "<pre class='CodeRay'>#{string}</pre>"
      end
    end
    
    def prettify(string)
      translate = {
        'ruby' => 'rb',
        'bash' => 'bsh',
        'javascript' => 'js',
        'python' => 'py'
      }
      lang = "unknown"
      if /\A:::(\w+)\s*\n/ =~ string  # extract language name
        lang = $1
        str = string.sub(/\A.*\n/, "")
        "<pre class='prettyprint lang-#{translate[lang] || lang}'>#{str}</pre>"
      else
        "<pre>#{string}</pre>"
      end
    end

    def ultraviolet(string)
      opts = { :theme => 'espresso_libre', :lines => false }
      opts.merge! @opts
      lang = 'text'
      if /\A:::(\w+)\s*\n/ =~ string  # extract language name
        lang = $1
        str = unescape_html(string.sub(/\A.*\n/, ""))
        "<pre class='#{opts[:theme]}'>#{::Uv.parse(str, 'xhtml', lang, opts[:lines], opts[:theme])}</pre>"
      else
        "<pre class='#{opts[:theme]}'>#{string}</pre>"
      end
    end
    
    def unescape_html(string)
      string.gsub("&lt;", '<').gsub("&gt;", '>').gsub("&amp;", '&')
    end
    
  end
end
