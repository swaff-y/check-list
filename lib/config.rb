# frozen_string_literal: true

module CheckList
  # Check-list version number
  class Config
    def self.version
      '0.0.0'
    end

    def self.default_url
      'https://raw.githubusercontent.com/swaff-y/check-list/main/lib/checklist.json'
    end

    def self.env
      'CHECK_LIST'
    end

    def self.coverage
      80
    end

    def self.time_now
      t = Time.now
      year = t.year
      month = t.month.to_s.rjust(2, '0')
      day = t.day.to_s.rjust(2, '0')
      hr = t.hour.to_s.rjust(2, '0')
      min = t.min.to_s.rjust(2, '0')
      "#{year}-#{month}-#{day} #{hr}:#{min}"
    end

    def self.path
      ret_path = nil
      $LOAD_PATH.each do |path|
        if path.match(/check_list-/)
          ret_path = path
          break
        end
      end
      ret_path
    end
  end
end
