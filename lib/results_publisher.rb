# frozen_string_literal: true

require 'json'
require 'fileutils'

module CheckList
  # Publish the results of a completed checklist
  class ResultsPublisher
    def initialize(results)
      @path = nil
      @results = results
      @checklist = CheckList::Helpers.system_cmd('ls | grep checklist')
      publish_results
      move_build_to_checklist
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
      $LOAD_PATH.each do |path|
        if path.match(/check_list-/)
          @path = path
          break
        end
      end

      return if @path.nil?

      CheckList::Helpers.system_cmd "cp -r #{@path}/build ./checklist/"
    end

    def create_checklist_folder
      data_hash = { 'results' => [] }
      FileUtils.mkdir_p('checklist')

      data_hash['results'].push @results
      write_json_file(data_hash)
      data_hash
    end

    def write_json_file(data_hash)
      File.write('./checklist/data.json', JSON.pretty_generate(data_hash))
    end
  end
end
