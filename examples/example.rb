path = File.expand_path("../lib")
$:.unshift(path) unless $:.include?(path)

require 'rubygems'
require 'sinatra'
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
