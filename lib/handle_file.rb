# frozen_string_literal: true

require_relative 'helpers'
require_relative 'config'
require 'net/http'

module CheckList
  # Displays the keyword/method provided
  class HandleFile
    def initialize
      @default_file = nil
      fetch_default_file
    end

    def fetch_default_file
      uri = URI.parse(CheckList::Config.default_url)
      @default_file = Net::HTTP.get_response(uri)
    rescue StandardError
      @default_file = nil
    end

    def fetch_json(env_key)
      url = './checklist/data.json'
      url = ENV.fetch(env_key) if CheckList::Config.env == env_key
      JSON.parse(File.read(url))
    rescue StandardError => e
      if env_key == CheckList::Config.env && !@default_file.nil?
        JSON.parse(@default_file.body)
      else
        CheckList::Helpers.log "Invalid file: #{e}"
        CheckList::Helpers.leave
      end
    end
  end
end
