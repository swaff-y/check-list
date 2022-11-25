# frozen_string_literal: true

require 'optimist'
require_relative 'menu'
require_relative 'list'
require_relative 'config'
require_relative 'handle_file'

module CheckList
  # The start method for check-list
  class Start
    attr_reader :opts

    def initialize
      @opts = set_options
      @filepath = CheckList::HandleFile.new
      handler
    end

    # rubocop: disable Layout/HeredocIndentation
    # rubocop: disable Naming/HeredocDelimiterNaming
    # rubocop: disable Metrics/MethodLength
    def set_options
      Optimist.options do
        version "check-list #{CheckList::Config.version} (c) 2022 Kyle Swaffield"
        banner <<~EOS
            Check-List

        Usage:
        check-list [options] <list name> | <reference name>
        where [options] are:
        EOS
        opt :list, 'checklist name', :type => :string # flag --list, default false
        opt :ref, 'Reference', :type => :string # flag --ref, default false
      end
    end
    # rubocop: enable Layout/HeredocIndentation
    # rubocop: enable Naming/HeredocDelimiterNaming
    # rubocop: enable Metrics/MethodLength

    def handler
      return CheckList::Menu.new(@filepath, @opts) if @opts[:list].nil?

      CheckList::List.new(@filepath)
    end
  end
end
