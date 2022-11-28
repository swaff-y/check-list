# frozen_string_literal: true

require_relative 'helpers'
require_relative 'config'

module CheckList
  # Class to build the selection menu
  class View
    def initialize
      open_browser_view
    end

    private

    def open_browser_view
      CheckList::Helpers.system_cmd("open #{CheckList::Config.path}/build/index.html")
    end
  end
end
