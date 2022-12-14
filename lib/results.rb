# frozen_string_literal: true

require 'json'
require 'fileutils'
require_relative 'config'
require_relative 'helpers'
require_relative 'handle_file'
require_relative 'exceptions'
require_relative 'results_publisher'
require_relative 'display_results'

module CheckList
  # Class to build the selection menu
  class Results
    attr_reader :results

    def initialize(opts)
      @ref = nil
      @opts = opts
      @results_array = []
      @results = {}
      process_opts
    end

    def process_opts
        return @ref = @opts[:ref] unless @opts[:ref].nil?

        @ref = 'main'
        begin
            branch = CheckList::Helpers.system_cmd("git status | grep 'On branch'")
            @ref = branch.chomp.gsub(/On branch /, '')
        rescue StandardError
            CheckList::Helpers.log 'Error with branch, using default'
        end
        @ref
    end

    def process_value(list, value, task, sub_task)
        result = {
          'list': list['name'],
          'task': task['name'],
          'subTask': sub_task['name'],
          'value': value,
          'timestamp': CheckList::Config.time_now
        }
        @results_array.push result
    end

    def process_results
      CheckList::Helpers.clear

      begin
          create_results_list
          create_tasks
          add_sub_tasks
          update_tasks
          CheckList::ResultsPublisher.new(@results)
          CheckList::DisplayResults.new(@results)
      rescue CheckList::Exceptions::InvalidListError => e
          CheckList::Helpers.log "Invalid List: #{e}"
          CheckList::Helpers.leave
      rescue StandardError => e
          CheckList::Helpers.log "Error: #{e}"
          CheckList::Helpers.leave
      end
    end

    private

    def update_tasks
        @results[:tasks].each_with_index do |result, index|
            status = 'n'
            result[:subTasks].each do |sub_task|
                if sub_task[:status] == 'n'
                    status = 'n'
                    break
                else
                    status = 'y'
                end
            end
            @results[:tasks][index][:status] = status
            @results[:tasks][index][:user] = ENV.fetch('USER')
            @results[:tasks][index][:time] = CheckList::Config.time_now
        end
    end

    def add_sub_tasks
        @results_array.each do |result|
            task = @results[:tasks].index do |e|
                e[:name] == result[:task]
            end

            res_hash = { name: result[:subTask], status: result[:value], time: result[:timestamp], user: ENV.fetch('USER') }
            @results[:tasks][task][:subTasks].push res_hash
        end
    end

    def create_tasks
        @results[:tasks] = []
        @results_array.each do |result|
            res = { name: result[:task], status: 'n', time: '', subTasks: [] }
            raise CheckList::Exceptions::InvalidListError, 'The list does not have a name' if @results[:name].nil?

            if @results[:tasks].empty?
                @results[:tasks].push res
            elsif @results[:tasks].include? name: result[:task], status: 'n', time: '', subTasks: []
                next
            else
                @results[:tasks].push res
            end
        end
    end

    def create_results_list
        @results[:name] = nil
        @results[:ref] = @ref
        @results_array.each do |result|
            if @results[:name].nil?
                @results[:name] = result[:list]
            elsif @results[:name] != result[:list]
                raise CheckList::Exceptions::InvalidListError, 'The list can only contain one list title'
            end
        end
    end
  end
end
