# frozen_string_literal: true

require_relative 'helpers'

module SpecRefLib
  # Displays the keyword/method provided
  class HandleFile
    def initialize
      @filepath = nil
    end
    # rubocop: disable Metrics/MethodLength
    def fetch_file
      begin
        @filepath = ENV.fetch('SPEC_REF_LIB')
      rescue StandardError
        # use default location if not present
        @filepath = nil
      end

      if @filepath.nil?
        SpecRefLib::Helpers.log 'file path not set'
        SpecRefLib::Helpers.leave
        'no path set'
      else
        read_file
        return 'invalid path' if read_file == 'invalid path'
        'active'
      end
    end
    # rubocop: enable Metrics/MethodLength

    def fetch_json
      read_file
    end

    def read_file
      begin
        JSON.parse(File.read(@filepath))
      rescue StandardError
        SpecRefLib::Helpers.log 'Invalid file path'
        SpecRefLib::Helpers.leave
        'invalid path'
      end
    end
  end
end
