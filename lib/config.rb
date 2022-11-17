# frozen_string_literal: true

module CheckList
  # Specr version number
  class Config
    def self.version
      '0.0.0'
    end

    def self.default_url
      ''
    end

    def self.env
      'CHECK_LIST'
    end
  end
end
