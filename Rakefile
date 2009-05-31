require "rake"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name         = "rack-codehighlighter"
    gemspec.summary      = "Rack Middleware for Code Highlighting."
    gemspec.email        = "matwb@univ.gda.pl"  
    gemspec.homepage     = "http://github.com/wbzyl/rack-codehighlighter"
    gemspec.authors      = ["Wlodek Bzyl"]
    gemspec.description  = gemspec.summary
    
    gemspec.files = %w[LICENSE TODO Rakefile VERSION.yml] + FileList['lib/**/*.rb', "examples/**/*"]
    
    gemspec.add_runtime_dependency 'rack', '>=1.0.0'
    gemspec.add_runtime_dependency 'hpricot', '>=0.8.1'   
    
    gemspec.add_development_dependency 'rack-test', '>=0.3.0'
  end
rescue LoadError
  puts "Jeweler not available."
  puts "Install it with:"
  puts "  sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

#Rake::TestTask.new(:test) do |t|
#  t.libs << 'lib' << 'test'
#  t.pattern = 'test/**/*_test.rb'
#  t.verbose = false
#end
