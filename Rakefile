# -*- coding: utf-8 -*-

require "rubygems"
require "rake/gempackagetask"
require "rake/clean"

spec = Gem::Specification.new do |s|
  s.name         = "codehighlighter-middleware"
  s.version      = "0.0.2"
  s.author       = "Włodek Bzyl"
  s.email        = "matwb" + "@" + "univ.gda.pl"
  s.homepage     = "http://github.com/wbzyl/codehighlighter-middleware"
  s.summary      = "Rack Middleware for Code Highlighting."
  s.description  = s.summary
  s.files        = %w[Rakefile README.markdown TODO] + Dir["lib/**/*"] + Dir["examples/**/*"]
  
  s.has_rdoc = true
  s.extra_rdoc_files = %w(LICENSE)
  
#  s.add_dependency 'coderay', '>=0.8.312'
  s.add_dependency 'hpricot', '>=0.8.1'   
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

desc 'Install the package as a gem.'
task :install => [:clean, :package] do
  gem = Dir['pkg/*.gem'].first
  sh "sudo gem install --no-rdoc --no-ri --local #{gem}"
end
