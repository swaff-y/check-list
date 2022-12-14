# frozen_string_literal: true

module CheckList
  # Checklist Validations
  class Validations
    def self.validate(value, array)
      return 0 if value == 'q'

      return value.to_i if array && value.to_i < array.length + 1 && !value.to_i.zero?

      return false unless array

      nil
    end

    def self.validate_response(value)
        case value
        when 'y'
            value
        when 'n'
            value
        when 'na'
            value
        when 'q'
            value
        else
            0
        end
    end
  end
end
