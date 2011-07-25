require 'rubygems'

require 'coderay'
require 'uv'
require 'syntax/convertors/html'
require 'rygments'

str = "def hitch; end"

puts "---- Syntax ----"
puts Syntax::Convertors::HTML.for_syntax('ruby').convert(str)

puts "---- Coderay ----"
puts CodeRay.encoder(:html).encode(str, 'ruby')

puts "---- Ultraviolet ----"
puts Uv.parse(str, 'xhtml', 'ruby_experimental', false, 'dawn')

puts "---- Pygments ----"
puts Rygments.highlight_string(str, 'ruby', 'html')