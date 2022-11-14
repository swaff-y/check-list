# frozen_string_literal: true

module SpecRefLib
  # Specr version number
  class Config
    def self.version
      '0.0.0'
    end

    def self.default_url
      'https://raw.githubusercontent.com/swaff-y/spec-ref-lib/main/lib/specr.json'
    end

    def self.env
      'SPEC_REF_LIB'
    end
  end
end
