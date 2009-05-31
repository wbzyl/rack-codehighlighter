# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-codehighlighter}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Wlodek Bzyl"]
  s.date = %q{2009-05-31}
  s.description = %q{Rack Middleware for Code Highlighting.}
  s.email = %q{matwb@univ.gda.pl}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "TODO",
     "VERSION.yml",
     "examples/app.rb",
     "examples/config.ru",
     "examples/public/javascripts/lang-css.js",
     "examples/public/javascripts/lang-hs.js",
     "examples/public/javascripts/lang-lisp.js",
     "examples/public/javascripts/lang-lua.js",
     "examples/public/javascripts/lang-ml.js",
     "examples/public/javascripts/lang-proto.js",
     "examples/public/javascripts/lang-sql.js",
     "examples/public/javascripts/lang-vb.js",
     "examples/public/javascripts/lang-wiki.js",
     "examples/public/javascripts/prettify.js",
     "examples/public/stylesheets/application.css",
     "examples/public/stylesheets/coderay.css",
     "examples/public/stylesheets/prettify.css",
     "examples/public/stylesheets/syntax.css",
     "examples/public/stylesheets/uv.css",
     "examples/public/stylesheets/uv/amy.css",
     "examples/public/stylesheets/uv/blackboard.css",
     "examples/public/stylesheets/uv/cobalt.css",
     "examples/public/stylesheets/uv/dawn.css",
     "examples/public/stylesheets/uv/espresso_libre.css",
     "examples/public/stylesheets/uv/sunburst.css",
     "examples/public/stylesheets/uv/twilight.css",
     "examples/public/stylesheets/uv/zenburnesque.css",
     "examples/views/index.rdiscount",
     "examples/views/layout.rdiscount"
  ]
  s.homepage = %q{http://github.com/wbzyl/rack-codehighlighter}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Rack Middleware for Code Highlighting.}
  s.test_files = [
    "examples/app.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0.8.1"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.8.1"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.8.1"])
  end
end
