require 'rack/utils'
require 'nokogiri'

module Rack
  class Codehighlighter
    include Rack::Utils

    # for logging use
    FORMAT = %{%s - [%s] [%s] "%s %s%s %s" (%s) %d %d %0.4f\n}

    def initialize(app, highlighter = :censor, opts = {})
      @app = app
      @highlighter = highlighter
      @opts = {
        :element => "pre",
        :pattern => /\A:::([-\w]+)\s*(\n|&#x000A;)/i,  # &#x000A; == line feed
        :reason => "[[--  ugly code removed  --]]", #8-)
        :markdown => false
      }
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
        doc = Nokogiri::HTML(content, nil, 'UTF-8')
        nodes = doc.search(@opts[:element])
        nodes.each do |node|
          s = node.inner_html || "[++where is the code?++]"
          if @opts[:markdown]
            node.parent.swap(send(@highlighter, s))
          else
            node.swap(send(@highlighter, s))
          end
        end

        body = doc.to_html

        headers['Content-Length'] = bytesize(body).to_s

        log(env, status, headers, began_at) if @opts[:logging]
        [status, headers, [body]]
      else
        [status, headers, response]
      end
    end

    private

    def log(env, status, headers, began_at)
      # 127.0.0.1 - [ultraviolet] [10/Oct/2009 12:12:12] "GET /pastie HTTP/1.1" (text/html) 200 512 1.23
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

    # simplifies testing
    def censor(string)
      "<pre class='censor'>#{@opts[:reason]}</pre>"
    end

    def syntax(string)
      # allow use html instead of xml
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
        convertor = ::Syntax::Convertors::HTML.for_syntax translate[lang] || lang
        convertor.convert(unescape_html(string.sub(@opts[:pattern], "")) || "[=this can'n happen=]")
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

    # experimental Javascript highlighter
    def prettify(string)
      # prettify uses short names; I want to use full names
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

    def pygments(string)
      refs = @opts[:pattern].match(string)
      if refs
        lang = refs[1]
        str = unescape_html(string.sub(@opts[:pattern], ""))
        options = @opts[:options]
        Pygments.highlight(str, :lexer => lang, :formatter => 'html', :options => options)
      else
        "<pre>#{string}</pre>"
      end
    end

    def rygments(string)
      refs = @opts[:pattern].match(string)
      if refs
        lang = refs[1]
        str = unescape_html(string.sub(@opts[:pattern], ""))
        Rygments.highlight_string(str, lang, 'html')
      else
        "<pre>#{string}</pre>"
      end
    end

    def pygments_api(string)
      require 'net/http'
      require 'uri'
      lang = 'unknown'
      refs = @opts[:pattern].match(string)  # extract language name
      if refs
        lang = refs[1]
        str = unescape_html(string.sub(@opts[:pattern], ""))
        req = Net::HTTP.post_form(URI.parse('http://pygments.appspot.com/'),
                            {'lang' => lang, 'code' => str})
        "#{req.body}"
      else
        "<pre>#{string}</pre>"
      end
    end

    def ultraviolet(string)
      opts = { :theme => 'dawn', :lines => false, :themes => {} }
      opts.merge! @opts
      lang = 'text'
      refs = @opts[:pattern].match(string)  # extract language name
      if refs
        lang = refs[1]
        theme = opts[:themes].collect do |k,v|
          k if v.include? lang end.compact.first || opts[:theme]
        str = unescape_html(string.sub(@opts[:pattern], ""))
        "#{::Uv.parse(str, 'xhtml', lang, opts[:lines], theme)}"
      else
        "<pre class='#{opts[:theme]}'>#{string}</pre>"
      end
    end

    def unescape_html(string)
      string.to_s.gsub(/&#x000A;/i, "\n").gsub("&lt;", '<').gsub("&gt;", '>').gsub("&amp;", '&')
    end

  end
end
