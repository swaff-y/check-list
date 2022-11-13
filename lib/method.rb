# frozen_string_literal: true

require_relative 'helpers'
require_relative 'handle_file'

module SpecRefLib
  # Displays the keyword/method provided
  class Method
    def initialize(filepath, _method)
      SpecRefLib::Helpers.clear
      @status = filepath.fetch_file
      return unless @status == 'active'

      @json = filepath.fetch_json
      # validate / find method(method)
      show_method
    end

    def show_method
      puts 'Showing method here'
    end
  end
end
