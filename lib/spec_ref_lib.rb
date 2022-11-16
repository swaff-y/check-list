# frozen_string_literal: true

require 'optimist'
require_relative 'menu'
require_relative 'method'
require_relative 'config'
require_relative 'handle_file'

module SpecRefLib
  # The start method for spec-ref-lib
  class Start
    attr_reader :opts

    def initialize
      @opts = set_options
      @filepath = SpecRefLib::HandleFile.new
      handler
    end

    # rubocop: disable Layout/HeredocIndentation
    # rubocop: disable Naming/HeredocDelimiterNaming
    # rubocop: disable Metrics/MethodLength
    def set_options
      Optimist.options do
        version "spec-ref-lib #{SpecRefLib::Config.version} (c) 2022 Kyle Swaffield"
        banner <<~EOS
            Rspec library

        Usage:
        spec-ref-lib [options] <method name | file path>
        where [options] are:
        EOS
        opt :method, 'rspec keyword or method name', :type => :string # flag --method, default false
      end
    end
    # rubocop: enable Layout/HeredocIndentation
    # rubocop: enable Naming/HeredocDelimiterNaming
    # rubocop: enable Metrics/MethodLength

    def handler
      return SpecRefLib::Menu.new(@filepath) if @opts[:method].nil?

      SpecRefLib::Method.new(@filepath, @opts[:method])
    end
  end
end
