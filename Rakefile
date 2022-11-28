# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rake'
require 'rspec/core/rake_task'
require_relative 'lib/helpers'
require_relative 'lib/config'
require_relative 'lib/exceptions'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = %w[--display-cop-names --cache false --fail-level C lib]
end

RSpec::Core::RakeTask.new(:spec)

task :bi do
  CheckList::Helpers.log CheckList::Helpers.system_cmd('gem build check_list.gemspec')
  CheckList::Helpers.log '<-------------->'
  CheckList::Helpers.log CheckList::Helpers.system_cmd('gem install ./check_list-0.0.0.gem')
end

task :coverage do
  pwd = CheckList::Helpers.system_cmd('pwd').chomp
  cov_hash = JSON.parse(File.read("#{pwd}/coverage/.last_run.json"))
  if cov_hash['result']['line'] < CheckList::Config.coverage
    raise CheckList::Exceptions::CoverageError.new 
  end
end

task default: %i[rubocop spec coverage bi]




