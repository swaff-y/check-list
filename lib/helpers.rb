# frozen_string_literal: true

module CheckList
  # Class to build the selection menu
  class Helpers
    def self.good_bye
      clear
      log 'Good Bye'
      leave
    end

    def self.check_status(status)
      case status.downcase
      when 'y'
        "#{green}Complete#{white}"
      when 'n'
        "#{red}Not Complete#{white}"
      when 'na'
        "#{yellow}Not Applicable#{white}"
      end
    end

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

    def self.system_cmd(cmd)
      `#{cmd}`
    end

    def self.write_json_file(data_hash)
      File.write('./checklist/data.json', JSON.pretty_generate(data_hash))
    end

    def self.bg_red
      "\x1b[41m"
    end

    def self.bg_green
      "\x1b[42m"
    end

    def self.bg_yellow
      "\x1b[43m"
    end

    def self.bg_white
      "\x1b[47m"
    end

    def self.red
      "\x1b[31m"
    end

    def self.green
      "\x1b[32m"
    end

    def self.yellow
      "\x1b[33m"
    end

    def self.white
      "\x1b[37m"
    end
  end
end
