# frozen_string_literal: true

require_relative 'helpers'

module SpecRefLib
  # Displays the keyword/method provided
  class HandleFile
    FILEPATH = ENV.fetch('SPEC_REF_LIB')
    # rubocop: disable Metrics/MethodLength
    def self.fetch_file
      if FILEPATH.nil?
        SpecRefLib::Helpers.log 'file path not set'
        SpecRefLib::Helpers.leave
        'no path set'
      else
        begin
            JSON.parse(File.read(FILEPATH))
            'active'
        rescue StandardError
            SpecRefLib::Helpers.log 'Invalid file path'
            SpecRefLib::Helpers.leave
            'invalid path'
        end
      end
    end
    # rubocop: enable Metrics/MethodLength

    def self.fetch_json
      JSON.parse(File.read(FILEPATH))
    end
  end
end
