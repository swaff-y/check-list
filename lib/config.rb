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
      "#{t.year}-#{t.month}-#{t.day} #{t.hour}:#{t.min}"
    end
  end
end
