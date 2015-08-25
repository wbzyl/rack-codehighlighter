# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "rack-codehighlighter"
  s.version     = "0.5.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Włodek Bzyl"]
  s.email       = ["matwb@ug.edu.pl"]
  s.homepage    = "http://tao.inf.ug.edu.pl/"
  s.summary     = %q{Rack Middleware for Code Highlighting.}
  s.description = %q{Rack Middleware for Code Highlighting. Supports the most popular Ruby code highlighters.}

  s.add_runtime_dependency 'rack', '>= 1.0.0'
  s.add_runtime_dependency 'nokogiri', '>= 1.4.1'

  s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
