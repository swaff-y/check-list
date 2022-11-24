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

    def self.time_now
      t = Time.now
      "#{t.year}-#{t.month.to_s.rjust(2, "0")}-#{t.day.to_s.rjust(2, "0")} #{t.hour.to_s.rjust(2, "0")}:#{t.min.to_s.rjust(2, "0")}"
    end
  end
end
