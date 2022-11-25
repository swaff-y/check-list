# frozen_string_literal: true

module CheckList
  # Display the results of a completed checklist
  class DisplayResults
    def initialize(results)
      @results = results
      display_results
    end

    private

    def display_results
      # CheckList::Helpers.log @results
    end
  end
end
