# frozen_string_literal: true

require_relative "fuzzy_time_ago/version"

module FuzzyTimeAgo
  class Error < StandardError; end
  Difference = Struct.new(:seconds, :minutes, :hours, :days, :weeks, :months, :years)

  # Convert a timestamp into a fuzzy, human-readable string specifying the difference to current system time
  def self.fuzzy_ago(target_time)
    raise ArgumentError, "Expected Time or Date object" unless target_time.is_a?(Time) || target_time.is_a?(Date)
    target_time = target_time.to_time if target_time.is_a?(Date)

    now = Time.now
    delta = now.to_i - target_time.to_i

    case delta
      when 0...60 then return "less than a minute ago"
      when 60...120 then return "about a minute ago"
      when 120...3600 then return "#{(delta / 60).to_i} minutes ago"
      when 3600...7200 then return "about an hour ago"
      when 7200...24*3600 then return "about #{(delta / 3600).to_i} hours ago"
      when 24*3600...48*3600 then return "a day ago"
      when 48*3600...7*24*3600 then return "#{(delta / (24*3600)).to_i} days ago"
      when 7*24*3600...14*24*3600 then return "about a week ago"
    end

    months_ago = (now.month - target_time.month) + 12 * (now.year - target_time.year) 
    months_ago -= 1 if now.day < target_time.day
    # binding.break
    case months_ago
      when 0 then return "about #{(delta / (7*24*3600)).to_i} weeks ago"
      when 1 then return "about a month ago"
      when 2 then return "about 2 months ago"
      when 3...12 then return "#{months_ago} months ago"
      when 12...15 then return "about a year ago"
      when 15...21 then return "over a year ago"
    end

    years_ago = (months_ago / 12).to_i
    months_ago = months_ago % 12
    case months_ago
      when 0...3 then return "about #{years_ago} years ago"
      when 3...9 then return "over #{years_ago} years ago"
      when 9...12 then return "almost #{years_ago + 1} years ago"
    end
  end
end

# Add convenience method to Time class
class Time
  def fuzzy_ago
    FuzzyTimeAgo.fuzzy_ago(self)
  end
end
