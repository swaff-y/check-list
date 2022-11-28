# frozen_string_literal: true

module CheckList
  # Display the results of a completed checklist
  class DisplayResults
    def initialize(results)
      @path = nil
      @results = results
      display_results
    end

    private

    # rubocop:disable Metrics/MethodLength
    def display_results
      CheckList::Helpers.log "#{@results[:name]} Checklist: #{@results[:ref]}"
      CheckList::Helpers.log ''
      @results[:tasks].each_with_index do |task, index|
        CheckList::Helpers.log "#{CheckList::Helpers.white}  #{index + 1}. #{task[:name]}"
        @results[:tasks][index][:subTasks].each_with_index do |sub_task, idx|
          color = CheckList::Helpers.white
          case sub_task[:status]
          when 'y'
            color = CheckList::Helpers.green
            mark = '(/)'
          when 'n'
            color = CheckList::Helpers.red
            mark = '(x)'
          when 'na'
            color = CheckList::Helpers.yellow
            mark = '(*)'
          end
          # rubocop:disable Layout/LineLength
          CheckList::Helpers.log "#{color}    #{idx + 1}. #{sub_task[:name]}#{CheckList::Helpers.white} #{mark} #{sub_task[:time]}"
          # rubocop:enable Layout/LineLength
        end
      end
      CheckList::Helpers.log ''
      CheckList::Helpers.log "To view results in your browser use 'check-list --view'"
    end
    # rubocop:enable Metrics/MethodLength
  end
end
