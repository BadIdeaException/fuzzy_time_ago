# FuzzyTimeAgo

A Ruby gem that converts timestamps into fuzzy, human-friendly relative time strings like "less than a minute ago", "2 months ago", "over a year ago", etc. It is intended as a light-weight replacement to Rails' [`time-ago-in-words`](https://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html#method-i-time_ago_in_words), albeit not an exact replacement (see section [Differences](#differences))

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fuzzy_time_ago'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fuzzy_time_ago

## Usage

```ruby
require 'fuzzy_time_ago'

# Basic usage with Time or Date objects
FuzzyTimeAgo.fuzzy_ago(Time.now - 30)     # => "less than a minute ago"
FuzzyTimeAgo.fuzzy_ago(Time.now - 3600)   # => "about an hour ago"
FuzzyTimeAgo.fuzzy_ago(Date.today - 1)    # => "a day ago"

# Convenience method on Time objects
Time.now.fuzzy_ago                        # => "less than a minute ago"
(Time.now - 86400).fuzzy_ago              # => "a day ago"
```

### Output Specification

| Time Range | Output Format |
|:-----------|:--------------|
| 0-59 seconds | `"less than a minute ago"` |
| 60-119 seconds | `"about a minute ago"` |
| 2-59 minutes | `"X minutes ago"` |
| 1-2 hours | `"about an hour ago"` |
| 2-23 hours | `"about X hours ago"` |
| 1 day | `"a day ago"` |
| 2-6 days | `"X days ago"` |
| 1 week | `"about a week ago"` |
| 2+ weeks | `"about X weeks ago"` |
| 1 month | `"about a month ago"` |
| 2 months | `"about 2 months ago"` |
| 3-11 months | `"X months ago"` |
| 12 months - 15 months | `"about a year ago"` |
| 15 months - 21 months | `"over a year ago"` |
| 21 months - 2 years | `"almost 2 years ago"` |
| 2+ years | "about/over/almost X years ago" |

*Note: For periods longer than weeks, the gem uses calendar-based calculations rather than fixed day counts.*

## Differences from Rails' `time_ago_in_words`

### Output Format Differences

| Time Period | FuzzyTimeAgo | Rails `time_ago_in_words` | Explanation |
|:------------|:-------------|:--------------------------|:------------|
| 1 day | `"a day"` | `"1 day"` | Uses "a" instead of "1" |
| 1 week | `"about a week"` | `"7 days"` | Switches unit to weeks, while Rails continues to use days |
| 1 month | `"about a month"` | `"about 1 month"` | Uses "a" instead of "1" |
| 1 year | `"about a year"` | `"about 1 year"` | Uses "a" instead of "1" |

### Calendar Arithmetic vs Fixed Duration

**The most significant difference is in how longer periods are calculated:**

- **FuzzyTimeAgo**: Uses true calendar arithmetic
  - Calculates months by actual calendar months
  - Adjusts for day-of-month differences
  - Respects varying month lengths (28-31 days) and leap years

- **Rails**: Uses fixed duration approximations
  - Assumes all months are 30 days
  - Assumes all years are 365 days
  - Only accounts for leap years in final year calculation, not month calculations

**Practical impact**: For periods longer than weeks, this gem will be more accurate for actual calendar dates, while Rails provides consistent duration-based approximations.

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

For version management, this gem uses [`bump`](https://github.com/gregorym/bump):
```
bundle exec rake bump:major
bundle exec rake bump:patch
bundle exec rake bump:minor
bundle exec rake bump:pre
```
Release and publishing are automated through a Github Actions workflow.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BadIdeaException/fuzzy_time_ago.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).