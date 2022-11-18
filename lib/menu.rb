# frozen_string_literal: true

require 'json'
require_relative 'config'
require_relative 'helpers'
require_relative 'handle_file'

module CheckList
    # Class to build the selection menu
    class Menu
        def initialize(filepath)
            @list = nil
            @task_idx = nil
            @sub_task_idx = nil
            @results = Hash.new
            @json = filepath.fetch_json
            show_menu
        end

        def show_menu
            CheckList::Helpers.clear
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

            show_sub_tasks
            # @task_idx += 1
            # value = validate_response(CheckList::Helpers.ret_value)
            # process_value(value, @list['tasks'][@task_idx - 1])
            return show_tasks if @task_idx < @list['tasks'].length

            process_results
        end

        def show_sub_tasks
            CheckList::Helpers.clear
            CheckList::Helpers.log "#{@task_idx + 1}. #{@list['tasks'][@task_idx]['name']}"

            @sub_task_idx = 0 if @sub_task_idx.nil?
            task = @list['tasks'][@task_idx]
            sub_tasks = @list['tasks'][@task_idx]['subTasks']

            CheckList::Helpers.log "  #{@sub_task_idx + 1}. #{sub_tasks[@sub_task_idx]['name']}"
            @sub_task_idx += 1
            value = validate_response(CheckList::Helpers.ret_value)
            process_value(value, task, sub_tasks[@sub_task_idx - 1]  )
            return show_sub_tasks if @sub_task_idx < sub_tasks.length

            @sub_task_idx = nil
            @task_idx += 1
        end

        def process_value(value, task, sub_task)
            CheckList::Helpers.log value
            CheckList::Helpers.log task
            CheckList::Helpers.log sub_task
        end

        def process_results
            CheckList::Helpers.clear
            CheckList::Helpers.log 'Results'
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
                show_tasks
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
