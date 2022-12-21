# frozen_string_literal: true

require_relative 'helpers'
require_relative 'config'
require_relative 'display_results'
require_relative 'symbolize'

module CheckList
  # Class to handle updates
  class Update
    HELP = CheckList::Helpers

    def initialize(opts, filepath)
      @opts = opts
      @json = filepath.fetch_json('CHECKLIST')
    end

    def show_lists(type)
      HELP.clear if type.is_a? String
      HELP.log 'Edit Cancelled' if type.is_a? String
      HELP.log 'Lists'
      HELP.log ''

      @json['results'].each_with_index do |list, index|
        HELP.log "#{index + 1}. #{list['name']} (#{list['ref']})"
      end

      value = validate_ret_value(HELP.ret_value, @json['results'])

      return show_list(value, nil) unless value.zero?

      HELP.clear
      show_lists(type)
    end

    def check_for_q(value)
      return HELP.good_bye if value.downcase == 'q'

      value
    end

    def validate_ret_value(value, arr)
      val = arr.length
      return value.to_i if !value.to_i.zero? && value.to_i <= val

      return check_for_q(value) if value == 'q'

      0
    rescue StandardError
      HELP.log 'Incorrect value'
      0
    end

    def show_list(value, type)
      HELP.clear
      HELP.log 'Invalid selection' if type.is_a? String

      name = @json['results'][value - 1]['name']
      ref = @json['results'][value - 1]['ref']
      @list = @json['results'][value - 1]
      HELP.log "List: #{name} (#{ref})"
      @json['results'][value - 1]['tasks'].each_with_index do |task, index|
        HELP.log "#{index + 1}. #{task['name']} (status: #{HELP.check_status(task['status'])})"
        task['subTasks'].each_with_index do |sub_task, idx|
          HELP.log "  #{idx + 1}. #{sub_task['name']} (status: #{HELP.check_status(sub_task['status'])})"
        end
      end
      edit(value)
    rescue StandardError => e
      HELP.log "Error: #{e}"
      HELP.leave
    end

    def edit(orig_value)
      value = check_for_q(HELP.ret_value)

      val_arr = nil
      val_arr = value.split(',', -1) if value.match(/^[-,0-9]+$/)
      arr_length = val_arr.length unless val_arr.nil?

      case arr_length
      when 1
        return show_list(orig_value, 'yes') if val_arr[0].to_i.zero?

        return show_sub_tasks(val_arr[0].to_i, orig_value)
      when 2
        return show_list(orig_value, 'yes') if val_arr[0].to_i.zero? || val_arr[1].to_i.zero?

        return edit_sub_task(val_arr[0].to_i, val_arr[1].to_i, orig_value)
      end
      show_list(orig_value, 'yes')
    end

    def show_sub_tasks(task_idx, orig_value)
      HELP.clear
      task = @list['tasks'][task_idx - 1]
      HELP.log task['name']
      task['subTasks'].each_with_index do |tsk, idx|
        HELP.log "  #{idx + 1}. #{tsk['name']} (status: #{HELP.check_status(tsk['status'])})"
      end
      sub_task_idx = check_for_q(HELP.ret_value)
      return show_list(orig_value, 'yes') if sub_task_idx.to_i.zero?

      edit_sub_task(task_idx, sub_task_idx.to_i, orig_value)
    rescue StandardError
      show_list(orig_value, 'yes')
    end

    def edit_sub_task(task_idx, sub_task_idx, orig_value)
      HELP.clear
      task = @list['tasks'][task_idx - 1]
      sub_task = task['subTasks'][sub_task_idx - 1]

      HELP.log "#{sub_task['name']} (status: #{HELP.check_status(sub_task['status'])})"
      HELP.log "Change: (#{HELP.green}yes#{HELP.white}/#{HELP.red}no#{HELP.white})"

      value = check_for_q(HELP.ret_value)
      yes = "#{HELP.green}y#{HELP.white}"
      no = "#{HELP.red}n#{HELP.white}"
      na = "#{HELP.yellow}na#{HELP.white}"
      HELP.log "Status: (#{yes}/#{no}/#{na})" if verify_edit(value)
      value = check_for_q(HELP.ret_value)
      update_results(value, orig_value, task_idx, sub_task_idx)
    rescue StandardError
      show_list(orig_value, 'yes')
    end

    def update_results(value, orig_value, task_idx, sub_task_idx)
      list = @json['results'][orig_value - 1]
      task = list['tasks'][task_idx - 1]
      subtask = task['subTasks'][sub_task_idx - 1]
      subtasks = task['subTasks']
      subtask['status'] = value
      subtask['time'] = CheckList::Config.time_now

      task['status'] = 'y'
      task['time'] = CheckList::Config.time_now
      subtasks.each do |tsk|
        if tsk['status'] == 'n'
          task['status'] = 'n'
          break
        end
      end

      HELP.write_json_file(@json)
      list = Sym.new(list).hash
      CheckList::DisplayResults.new(list)
    end

    def verify_edit(value)
      return show_lists('yes') unless value.downcase == 'yes'

      true
    end
  end
end
