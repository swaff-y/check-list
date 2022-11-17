# frozen_string_literal: true

require_relative './lib/config'

Gem::Specification.new do |s|
  s.name        = 'check_list'
  s.version     = CheckList::Config.version
  s.summary     = ''
  s.description = 'A cli checklist'
  s.authors     = ['Kyle Swaffield']
  s.email       = 'kyle@swaff.iu.au'
  s.files       = [
    'lib/check_list.rb',
    'lib/handle_file.rb',
    'lib/helpers.rb',
    'lib/menu.rb',
    'lib/list.rb',
    'lib/config.rb',
  ]
  s.homepage    = 'https://rubygems.org/gems/check_list'
  s.license     = 'MIT'
  s.executables << 'check-list'
  s.required_ruby_version = '>= 2.6'
end
