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

    def make_mark(status)
      case status
      when 'y'
        "#{make_color(status)}(/)#{CheckList::Helpers.white}"
      when 'n'
        "#{make_color(status)}(x)#{CheckList::Helpers.white}"
      when 'na'
        "#{make_color(status)}(*)#{CheckList::Helpers.white}"
      end
    end

    def make_color(status)
      case status
      when 'y'
        CheckList::Helpers.green
      when 'n'
        CheckList::Helpers.red
      when 'na'
        CheckList::Helpers.yellow
      end
    end

    def display_results
      CheckList::Helpers.clear
      CheckList::Helpers.log "*#{@results[:name]}* Checklist: #{@results[:ref]}"
      CheckList::Helpers.log ''
      @results[:tasks].each_with_index do |task, index|
        CheckList::Helpers.log "  #{make_color(task[:status])}#{index + 1}.#{CheckList::Helpers.white} #{task[:name]} #{make_mark(task[:status])} _#{task[:time]}_"
        @results[:tasks][index][:subTasks].each_with_index do |sub_task, idx|
          CheckList::Helpers.log "    #{make_color(sub_task[:status])}#{idx + 1}.#{CheckList::Helpers.white} #{sub_task[:name]}#{CheckList::Helpers.white} #{make_mark(sub_task[:status])} _#{sub_task[:time]}_"
        end
      end
      CheckList::Helpers.log ''
      CheckList::Helpers.log "To view results in your browser use 'check-list --view'"
    end
  end
end
