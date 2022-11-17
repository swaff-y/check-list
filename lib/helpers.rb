# frozen_string_literal: true

module CheckList
  # Class to build the selection menu
  class Helpers
    def self.clear
      system 'clear'
    end

    def self.log(str)
      puts str
    end

    def self.ret_value
      $stdin.gets.chomp
    end

    def self.leave
      exit
    end
  end
end
