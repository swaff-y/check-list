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

      return show_list unless value.zero?

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

    def show_list
      CheckList::Helpers.clear
      CheckList::Helpers.log 'List'
    end
  end
end
