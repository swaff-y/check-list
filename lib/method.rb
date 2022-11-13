# frozen_string_literal: true

module SpecRefLib
  # Displays the keyword/method provided
  class Method
    FILEPATH = ENV.fetch('SPEC_REF_LIB')
    def initialize(method)
      SpecRefLib::Helpers.clear
      puts method
    end
  end
end
