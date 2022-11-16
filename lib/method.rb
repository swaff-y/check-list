# frozen_string_literal: true

require_relative 'helpers'
require_relative 'handle_file'

module SpecRefLib
  # Displays the keyword/method provided
  class Method
    def initialize(filepath, method)
      @found = false
      SpecRefLib::Helpers.clear
      @keyword_array = []
      @json = filepath.fetch_json
      show_method(method)
    end

    def show_method(method)
      @json['categories'].each do |category|
        category['categories'].each do |cat|
          next unless cat['keywords'].include? method

          SpecRefLib::Helpers.log cat['example']
          SpecRefLib::Helpers.log ''
          @found = true
        end
      end
      SpecRefLib::Helpers.log 'No keywords found' unless @found
      handle_input(SpecRefLib::Helpers.ret_value)
    end

    def handle_input(value)
      SpecRefLib::Helpers.clear

      if value == 'q'
        SpecRefLib::Helpers.log 'Good Bye'
        return SpecRefLib::Helpers.leave
      end

      SpecRefLib::Start.new
    end
  end
end
