# frozen_string_literal: true

require_relative 'helpers'

module CheckList
  # Class to handle updates
  class Update
    HELP = CheckList::Helpers

    def initialize(opts, filepath)
      @opts = opts
      @json = filepath.fetch_json('CHECKLIST')
    end

    def show_lists
      HELP.log 'Lists'
      HELP.log ''

      @json['results'].each_with_index do |list, index|
        HELP.log "#{index + 1}. #{list['name']}"
      end

      value = validate_ret_value(HELP.ret_value, @json['results'])

      return show_list(value) unless value.zero?

      HELP.clear
      show_lists
    end

    def validate_ret_value(value, arr)
      val = arr.length
      return value.to_i if !value.to_i.zero? && value.to_i <= val

      return HELP.good_bye if value == 'q'

      0
    rescue StandardError
      HELP.log 'Incorrect value'
      0
    end

    # rubocop:disable Metrics/MethodLength
    def show_list(value)
      HELP.clear
      name = @json['results'][value - 1]['name']
      ref = @json['results'][value - 1]['ref']
      HELP.log "List: #{name} #{ref}"
      @json['results'][value - 1]['tasks'].each_with_index do |task, index|
        HELP.log "#{index + 1}. #{task['name']} status: #{HELP.check_status(task['status'])}"
        task['subTasks'].each_with_index do |sub_task, idx|
          HELP.log "  #{idx + 1}. #{sub_task['name']} status: #{HELP.check_status(sub_task['status'])}"
        end
      end
      # update_sub_task
    rescue StandardError => e
      HELP.log "Error: #{e}"
      HELP.leave
    end
    # rubocop:enable Metrics/MethodLength
  end
end
