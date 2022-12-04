# frozen_string_literal: true

require 'json'
require 'fileutils'
require_relative 'config'

module CheckList
  # Publish the results of a completed checklist
  class ResultsPublisher
    def initialize(results)
      @path = nil
      @results = results
      @checklist = CheckList::Helpers.system_cmd('ls | grep checklist')
      publish_results
    end

    private

    def publish_results
      return create_checklist_folder if @checklist == ''

      # TODO: Go through all results. If changed then replace.
      file = File.read('./checklist/data.json')
      data_hash = JSON.parse(file)

      data_hash['results'] = data_hash['results'].reject do |res|
          res['name'] == @results[:name] && res['ref'] == @results[:ref]
      end

      data_hash['results'].push @results
      write_json_file(data_hash)
      data_hash
    end

    def move_build_to_checklist
      @path = CheckList::Config.path

      return if @path.nil?

      CheckList::Helpers.system_cmd "cp -r #{@path}/build/ ./checklist/"
    end

    def create_checklist_folder
      data_hash = { 'results' => [] }
      FileUtils.mkdir_p('checklist')
      move_build_to_checklist

      data_hash['results'].push @results
      write_json_file(data_hash)
      data_hash
    end

    def write_json_file(data_hash)
      File.write('./checklist/data.json', JSON.pretty_generate(data_hash))
    end
  end
end
