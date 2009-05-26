# -*- coding: utf-8 -*-

require 'rack'
require 'rack/utils'
require 'hpricot'

module Rack
  class Codehighlighter
    include Rack::Utils
    
    #FORMAT = %{%s [%s] %s [%s] "%s%s%s%" %d %s %0.4f\n}
    FORMAT = %{%s - [%s] %s [%s] "%s %s%s %s" %d %s %0.4f\n}
    
    def initialize(app, highlighter = :syntax, opts = {})
      @app = app
      @highlighter = highlighter
      @opts = opts
    end
    def call(env)
      began_at = Time.now
      status, headers, response = @app.call(env)
      headers = HeaderHash.new(headers)

      log(env, status, headers, began_at)
      
#       if !STATUS_WITH_NO_ENTITY_BODY.include?(status) &&
#          !headers['Content-Length'] &&
#          !headers['Transfer-Encoding'] &&
#          (body.respond_to?(:to_ary) || body.respond_to?(:to_str))

#         length = body.to_ary.inject(0) { |len, part| len + bytesize(part) }
#         headers['Content-Length'] = length.to_s
#       end
      
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

    def log(env, status, headers, began_at)
      # lilith.local [coderay] text/html [26/may/2009 12:00:00] "GET / HTTP/1.1" 200 ? ?\n
      now = Time.now
      length = 1024 # ???
      logger = env['rack.errors']
      logger.write FORMAT % [
        env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"] || "-",
        @highlighter,
        headers["content-type"] || "unknown",
        now.strftime("%d/%b/%Y %H:%M:%S"),
        env["REQUEST_METHOD"],
        env["PATH_INFO"],
        env["QUERY_STRING"].empty? ? "" : "?"+env["QUERY_STRING"],
        env["HTTP_VERSION"],
        status.to_s[0..3],
        length,
        now - began_at
      ]
    end
    
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
