require 'rack/utils'

gem 'hpricot', '>=0.8.1'
require 'hpricot'

module Rack
  class Codehighlighter
    include Rack::Utils
    
    FORMAT = %{%s - [%s] [%s] "%s %s%s %s" (%s) %d %d %0.4f\n}
    
    def initialize(app, highlighter = :coderay, opts = {})
      @app = app
      @highlighter = highlighter
      
      @opts = { :element => "//pre/code", :pattern => /\A:::(\w+)\s*\n/ }
      
      @opts.merge! opts
    end

    def call(env)
      began_at = Time.now
      status, headers, response = @app.call(env)
      headers = HeaderHash.new(headers)

      if !STATUS_WITH_NO_ENTITY_BODY.include?(status) &&
         !headers['transfer-encoding'] &&
          headers['content-type'] &&
          headers['content-type'].include?("text/html")

        content = ""
        response.each { |part| content += part }
        doc = Hpricot(content)
        nodes = doc.search(@opts[:element])
        nodes.each do |node|
          s = node.inner_html || "[++where is the code?++]"
          node.parent.swap(send(@highlighter, s))
        end

        body = doc.to_html
        headers['content-length'] = body.bytesize.to_s

        log(env, status, headers, began_at) if @opts[:logging]
        [status, headers, [body]]
      else
        [status, headers, response]  
      end
    end
    
    private

    def log(env, status, headers, began_at)
      # lilith.local [coderay] text/html [26/may/2009 12:00:00] "GET / HTTP/1.1" 200 ? ?\n
      now = Time.now
       logger = env['rack.errors']
      logger.write FORMAT % [
        env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"] || "-",
        @highlighter,
        now.strftime("%d/%b/%Y %H:%M:%S"),
        env["REQUEST_METHOD"],
        env["PATH_INFO"],
        env["QUERY_STRING"].empty? ? "" : "?"+env["QUERY_STRING"],
        env["HTTP_VERSION"],
        headers["content-type"] || "unknown",
        status.to_s[0..3],
        headers['content-length'],
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
      lang = 'unknown'
      refs = @opts[:pattern].match(string)  # extract language name
      if refs
        lang = refs[1]
        convertor = ::Syntax::Convertors::HTML.for_syntax translate[lang]
        convertor.convert(unescape_html(string.sub(/\A.*\n/, "")) || "[=this can'n happen=]")
      else
        "<pre>#{string}</pre>"
      end
    end
    
    def coderay(string)
      lang = 'unknown'
      refs = @opts[:pattern].match(string)  # extract language name
      if refs
        lang = refs[1]
        str = unescape_html(string.sub(@opts[:pattern], ""))
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
      lang = 'unknown'
      refs = @opts[:pattern].match(string)  # extract language name
      if refs 
        lang = refs[1]
        str = string.sub(@opts[:pattern], "")
        "<pre class='prettyprint lang-#{translate[lang] || lang}'>#{str}</pre>"
      else
        "<pre>#{string}</pre>"
      end
    end

    def ultraviolet(string)
      opts = { :theme => 'dawn', :lines => false }
      opts.merge! @opts
      lang = 'text'
      refs = @opts[:pattern].match(string)  # extract language name
      if refs
        lang = refs[1]
        str = unescape_html(string.sub(@opts[:pattern], ""))
        "<pre class='#{opts[:theme]}'>#{::Uv.parse(str, 'xhtml', lang, opts[:lines], opts[:theme])}</pre>"
      else
        "<pre class='#{opts[:theme]}'>#{string}</pre>"
      end
    end
    
    def unescape_html(string)
      string.to_s.gsub("&lt;", '<').gsub("&gt;", '>').gsub("&amp;", '&')
    end
    
  end
end
