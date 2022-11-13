# frozen_string_literal: true

require 'optimist'
require_relative 'menu'
require_relative 'method'
require_relative 'version'

module SpecRefLib
  # The start method for spec-ref-lib
  class Start
    attr_reader :opts

    def initialize
      @opts = set_options
      handler
    end

    # rubocop: disable Layout/HeredocIndentation
    # rubocop: disable Naming/HeredocDelimiterNaming
    # rubocop: disable Metrics/MethodLength
    def set_options
      Optimist.options do
        version "spec-ref-lib #{SpecRefLib::Version.version} (c) 2022 Kyle Swaffield"
        banner <<~EOS
            Rspec library

        Usage:
        spec-ref-lib [options] <method name | file path>
        where [options] are:
        EOS
        opt :method, 'rspec keyword or method name', :type => :string # flag --method, default false
        opt :configure, 'configure file path for spec definitions', :type => :string
      end
    end
    # rubocop: enable Layout/HeredocIndentation
    # rubocop: enable Naming/HeredocDelimiterNaming
    # rubocop: enable Metrics/MethodLength

    def handler
      return SpecRefLib::Menu.new if @opts[:method].nil?

      SpecRefLib::Method.new(@opts[:method])
    end
  end
end
