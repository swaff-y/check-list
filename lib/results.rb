# frozen_string_literal: true

require 'json'
require_relative 'config'
require_relative 'helpers'
require_relative 'handle_file'
require_relative 'exceptions'

module CheckList
  # Class to build the selection menu
  class Results
    attr_reader :results
    def initialize
      @results_array = []
      @results = {}
    end

    def process_value(list, value, task, sub_task)
      result = {
          'list': list['name'],
          'task': task['name'],
          'subTask': sub_task['name'],
          'value': value
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
          CheckList::Helpers.log @results
      rescue CheckList::Exceptions::InvalidListError => e
          CheckList::Helpers.log "Invalid List: #{e}"
          CheckList::Helpers.leave
      # rescue StandardError => e
      #     CheckList::Helpers.log "Error: #{e}"
      #     CheckList::Helpers.leave
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
        end
    end

    def add_sub_tasks
        @results_array.each do |result|
            task = @results[:tasks].index do |e|
                e[:name] == result[:task]
            end

            @results[:tasks][task][:subTasks].push name: result[:subTask], status: result[:value]
        end
    end

    def create_tasks
        @results[:tasks] = [ ]
        @results_array.each do |result|
            res = { name: result[:task], status: 'n', subTasks: [] }

            if @results[:name].nil? 
                raise CheckList::Exceptions::InvalidListError.new 'The list does not have a name'
            elsif @results[:tasks].empty?
                @results[:tasks].push res
            elsif @results[:tasks].include? name: result[:task], status: 'n', subTasks: []
                next
            else
                @results[:tasks].push res
            end
        end
    end

    def create_results_list
        @results[:name] = nil
        @results_array.each do |result|
            if @results[:name].nil? 
                @results[:name] = result[:list]
            elsif @results[:name] != result[:list]
                raise CheckList::Exceptions::InvalidListError.new 'The list can only contain one list title'
            end
        end
    end
  end
end