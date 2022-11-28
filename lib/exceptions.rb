# frozen_string_literal: true

require_relative 'helpers'

module CheckList
  module Exceptions
    # Checklist errors
    class InvalidListError < StandardError
    end

    # Coverage errors
    class CoverageError < StandardError
      def initialize
        super
        CheckList::Helpers.log "#{CheckList::Helpers.red}Insufficient Coverage#{CheckList::Helpers.white}"
      end
    end
  end
end
