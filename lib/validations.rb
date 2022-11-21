# frozen_string_literal: true

module CheckList
  # Checlist Validations
  class Validations
    def self.validate(value, array)
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
    def self.validate_response(value)
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
  end
end