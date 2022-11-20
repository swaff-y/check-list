# frozen_string_literal: true

require 'json'
require_relative 'config'
require_relative 'helpers'
require_relative 'handle_file'
require_relative 'exceptions'

module CheckList
    # Class to build the selection menu
    class Menu
        attr_reader :results

        def initialize(filepath)
            @list = nil
            @task_idx = nil
            @sub_task_idx = nil
            @results = {}
            @results_array = []
            @json = filepath.fetch_json
            show_menu
        end

        def show_menu
            list_array = @json['lists']
            CheckList::Helpers.log 'Checklists'

            list_array.each_with_index do |list, index|
                CheckList::Helpers.log "#{index + 1}. #{list['name']}"
            end
            value = validate(CheckList::Helpers.ret_value, list_array)
            @list = get_list(value) unless value.nil?
            return show_tasks unless @list.nil?

            show_menu
        end

        def show_tasks
            @task_idx = 0 if @task_idx.nil?

            return process_results if @task_idx == @list['tasks'].length
            show_sub_tasks
        end

        def show_sub_tasks
            # This gaurd clause is neccecary to protect an incorrect value being entered causing an extra recrsive call to show_sub_tasks
            return if @task_idx == @list['tasks'].length
            CheckList::Helpers.clear

            CheckList::Helpers.log @list['name']
            CheckList::Helpers.log "#{@task_idx + 1}. #{@list['tasks'][@task_idx]['name']}"

            @sub_task_idx = 0 if @sub_task_idx.nil?
            task = @list['tasks'][@task_idx]
            sub_tasks = @list['tasks'][@task_idx]['subTasks']

            CheckList::Helpers.log "  #{@sub_task_idx + 1}. #{sub_tasks[@sub_task_idx]['name']} y/n/na"
            @sub_task_idx += 1
            value = validate_response(CheckList::Helpers.ret_value)
            process_value(value, task, sub_tasks[@sub_task_idx - 1]  )
            return show_sub_tasks if @sub_task_idx < sub_tasks.length

            @sub_task_idx = 0
            @task_idx += 1
            show_tasks
        end

        def process_value(value, task, sub_task)
            result = {
                'list': @list['name'],
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
            end
        end

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

        def get_list(value)
            @json['lists'][value - 1]
        end

        def validate(value, array)
            good_bye if value == 'q'

            # rubocop:disable Style/SoleNestedConditional
            if array && value.to_i < array.length + 1
                return value.to_i unless value.to_i.zero?
            end
            # rubocop:enable Style/SoleNestedConditional

            return false unless array

            nil
        end

        # rubocop:disable Metrics/MethodLength
        def validate_response(value)
            case value
            when 'y'
                value
            when 'n'
                value
            when 'na'
                value
            when 'q'
                good_bye
            else
                @sub_task_idx -= 1
                show_sub_tasks
            end
        end
        # rubocop:enable Metrics/MethodLength

        def good_bye
            CheckList::Helpers.clear
            CheckList::Helpers.log 'Good Bye'
            CheckList::Helpers.leave
        end
    end
end
