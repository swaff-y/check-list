# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rake'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end

RSpec::Core::RakeTask.new(:spec)

# rubocop:disable Style/HashSyntax
task :default => :rubocop
task :default => :spec
# rubocop:enable Style/HashSyntax
