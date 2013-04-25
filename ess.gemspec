# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ess/version'

Gem::Specification.new do |gem|
  gem.name          = "ess"
  gem.version       = ESS::VERSION
  gem.authors       = ["Marjan Povolni"]
  gem.email         = ["marian.povolny@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{Generate and parse ESS XML feeds with Ruby}
  gem.homepage      = "https://github.com/essfeed/ruby-ess"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
