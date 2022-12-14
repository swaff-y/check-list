# frozen_string_literal: true

require 'optimist'
require_relative 'menu'
require_relative 'list'
require_relative 'view'
require_relative 'config'
require_relative 'handle_file'
require_relative 'exceptions'
require_relative 'helpers'
require_relative 'update'

# Check-list application
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
        check-list [options] <list name> | <reference name>
        where [options] are:
        EOS
        opt :list, 'checklist name', :type => :string # flag --list, default false
        opt :ref, 'Reference', :type => :string # flag --ref, default false
        opt :view, 'View browser list'
        opt :update, 'Update list'
      end
    end
    # rubocop: enable Layout/HeredocIndentation
    # rubocop: enable Naming/HeredocDelimiterNaming

    def handler
      if @opts[:update_given]
        update
      elsif @opts[:view_given]
        view
      else
        CheckList::Menu.new(@filepath, @opts)
      end
    rescue CheckList::Exceptions::InvalidOptionError
      CheckList::Helpers.log 'Invalid list option selection'
    end

    def update
      @update = CheckList::Update.new(@opts, @filepath)
      return update_ref if @opts[:list_given] && @opts[:ref_given]

      update_list
    end

    def update_ref
      @update.show_list('', nil)
    end

    def update_list
      @update.show_lists(nil)
    end

    def view
      return view_ref if @opts[:list_given] && @opts[:ref_given]

      view_list
    end

    def view_ref
      puts 'view ref'
    end

    def view_list
      CheckList::View.new
    end
  end
end
