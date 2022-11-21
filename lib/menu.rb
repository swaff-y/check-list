# frozen_string_literal: true

require 'json'
require_relative 'config'
require_relative 'helpers'
require_relative 'handle_file'
require_relative 'exceptions'
require_relative 'results'
require_relative 'validations'

module CheckList
    # Class to build the selection menu
    class Menu
        attr_reader :results

        def initialize(filepath)
            @list = nil
            @task_idx = nil
            @sub_task_idx = nil
            @results = CheckList::Results.new
            @json = filepath.fetch_json
            show_menu
        end

        def show_menu
            list_array = @json['lists']
            CheckList::Helpers.log 'Checklists'

            list_array.each_with_index do |list, index|
                CheckList::Helpers.log "#{index + 1}. #{list['name']}"
            end
            value = CheckList::Validations.validate(CheckList::Helpers.ret_value, list_array)
            @list = get_list(value) unless value.nil?
            return show_tasks unless @list.nil?

            show_menu
        end

        def show_tasks
            @task_idx = 0 if @task_idx.nil?

            return @results.process_results if @task_idx == @list['tasks'].length

            show_sub_tasks
        end

        # rubocop:disable Metrics/MethodLength
        def show_sub_tasks
            # This gaurd clause is neccecary to protect an incorrect value being entered.
            # This causes an extra recrsive call to show_sub_tasks
            return if @task_idx == @list['tasks'].length

            CheckList::Helpers.clear
            CheckList::Helpers.log "#{@task_idx + 1}. #{@list['tasks'][@task_idx]['name']}"

            @sub_task_idx = 0 if @sub_task_idx.nil?
            task = @list['tasks'][@task_idx]
            sub_tasks = @list['tasks'][@task_idx]['subTasks']

            CheckList::Helpers.log "  #{@sub_task_idx + 1}. #{sub_tasks[@sub_task_idx]['name']} y/n/na"
            @sub_task_idx += 1
            value = CheckList::Validations.validate_response(CheckList::Helpers.ret_value)
            return good_bye if value == 'q'

            # rubocop: disable Style/NumericPredicate
            if value == 0
                @sub_task_idx -= 1
                return show_sub_tasks
            end
            # rubocop: enable Style/NumericPredicate

            @results.process_value(@list, value, task, sub_tasks[@sub_task_idx - 1])
            return show_sub_tasks if @sub_task_idx < sub_tasks.length

            @sub_task_idx = 0
            @task_idx += 1
            show_tasks
        end
        # rubocop:enable Metrics/MethodLength

        def get_list(value)
            @json['lists'][value - 1]
        end

        def good_bye
            CheckList::Helpers.clear
            CheckList::Helpers.log 'Good Bye'
            CheckList::Helpers.leave
        end
    end
end
