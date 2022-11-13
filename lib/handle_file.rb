# frozen_string_literal: true

require_relative 'helpers'

module SpecRefLib
  # Displays the keyword/method provided
  class HandleFile
    # rubocop: disable Metrics/MethodLength
    def self.fetch_file
      begin
        filepath = ENV.fetch('SPEC_REF_LIB')
      rescue StandardError
        filepath = nil
      end

      if filepath.nil?
        SpecRefLib::Helpers.log 'file path not set'
        SpecRefLib::Helpers.leave
        'no path set'
      else
        begin
            JSON.parse(File.read(ENV.fetch('SPEC_REF_LIB')))
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
      JSON.parse(File.read(ENV.fetch('SPEC_REF_LIB')))
    end
  end
end
