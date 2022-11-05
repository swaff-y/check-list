# frozen_string_literal: true

require_relative './lib/version'

Gem::Specification.new do |s|
  s.name        = 'specr'
  s.version     = Specr::Version.version
  s.summary     = ''
  s.description = 'A rspec library'
  s.authors     = ['Kyle Swaffield']
  s.email       = 'kyle@swaff.iu.au'
  s.files       = ['lib/specr.rb', 'lib/specr.json', 'lib/version.rb']
  s.homepage    = 'https://rubygems.org/gems/specr'
  s.license     = 'MIT'
  s.executables << 'specr'
  s.required_ruby_version = '>= 2.6'
end
