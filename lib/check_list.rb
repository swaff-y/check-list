# frozen_string_literal: true

require 'optimist'
require_relative 'menu'
require_relative 'method'
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
    def set_options
      Optimist.options do
        version "check-list #{CheckList::Config.version} (c) 2022 Kyle Swaffield"
        banner <<~EOS
            Check-List

        Usage:
        check-list [options] <list name>
        where [options] are:
        EOS
        opt :list, 'checklist name', :type => :string # flag --list, default false
      end
    end
    # rubocop: enable Layout/HeredocIndentation
    # rubocop: enable Naming/HeredocDelimiterNaming

    def handler
      return CheckList::Menu.new(@filepath) if @opts[:list].nil?

      CheckList::Method.new(@filepath, @opts[:list])
    end
  end
end
