# frozen_string_literal: true

require 'json'
require_relative 'config'
require_relative 'helpers'
require_relative 'handle_file'

module CheckList
    # Class to build the selection menu
    class Menu
        def initialize(filepath)
            CheckList::Helpers.clear
            @json = filepath.fetch_json
            show_menu
        end

        def show_menu
            CheckList::Helpers.log 'menu'
        end
    end
end
