# frozen_string_literal: true

require_relative 'helpers'

module CheckList
  # Class to handle updates
  class Update
    def initialize(opts, filepath)
      @opts = opts
      @json = filepath.fetch_json('CHECKLIST')
    end

    def show_lists
      CheckList::Helpers.log 'Lists'
      CheckList::Helpers.log ''

      @json['results'].each_with_index do |list, index|
        CheckList::Helpers.log "#{index + 1}. #{list['name']}"
      end

      value = validate_ret_value(CheckList::Helpers.ret_value, @json['results'])

      return show_list(value) unless value.zero?

      CheckList::Helpers.clear
      show_lists
    end

    def validate_ret_value(value, arr)
      val = arr.length
      return value.to_i if !value.to_i.zero? && value.to_i <= val

      return CheckList::Helpers.good_bye if value == 'q'

      0
    rescue StandardError
      CheckList::Helpers.log 'Incorrect value'
      0
    end

    def show_list(value)
      CheckList::Helpers.clear
      name = @json['results'][value - 1]['name']
      ref = @json['results'][value - 1]['ref']
      CheckList::Helpers.log "List: #{name} #{ref}"
      @json['results'][value - 1]['tasks'].each_with_index do |task, index|
        CheckList::Helpers.log "#{index + 1}. #{task['name']} status:#{task['status']}"
      end
    rescue StandardError => e
      CheckList::Helpers.log "Error: #{e}"
      CheckList::Helpers.leave
    end
  end
end
