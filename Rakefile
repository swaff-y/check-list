# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rake'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = %w[--display-cop-names --cache false --fail-level C lib]
end

RSpec::Core::RakeTask.new(:spec)

task default: %i[rubocop spec]
