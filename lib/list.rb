# frozen_string_literal: true

require 'json'
require_relative 'config'
require_relative 'helpers'
require_relative 'handle_file'

module CheckList
    # Class to build the selection menu
    class List
        def initialize(filepath, list)
            CheckList::Helpers.clear
            @json = filepath.fetch_json
            show_list
        end

        def show_list
            CheckList::Helpers.log 'list'
        end
    end
end
