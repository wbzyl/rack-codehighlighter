require "rubygems"
require "rake/gempackagetask"
require "rake/clean"
#require "spec/rake/spectask"

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '/lib')

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name         = "rack-codehighlighter"
    s.summary      = "Rack Middleware for Code Highlighting."
    s.email        = "matwb@univ.gda.pl"  
    s.homepage     = "http://github.com/wbzyl/rack-codehighlighter"
    s.authors      = ["Wlodek Bzyl"]
    s.description  = s.summary
  
    #  s.add_dependency 'coderay', '>=0.8.312'
    s.add_dependency 'hpricot', '>=0.8.1'   
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

desc 'Install the package as a gem.'
task :install => [:clean, :build] do
  gem = Dir['pkg/*.gem'].last
  sh "sudo gem install --no-rdoc --no-ri --local #{gem}"
end

task :default => :test
