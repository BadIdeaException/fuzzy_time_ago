# frozen_string_literal: true

require 'timecop'

MINUTES = 60
HOURS = 60 * MINUTES
DAYS = 24 * HOURS

RSpec.describe FuzzyTimeAgo do
  it 'has a version number' do
    expect(FuzzyTimeAgo::VERSION).not_to be_nil
  end

  describe '.fuzzy_ago' do
    # Make sure that we are in a non-leap year
    let(:now) { Time.new(2025, 9, 1, 12, 0, 0) }
    let(:today) { now.to_date }

    before { Timecop.freeze now }
    after { Timecop.return }

    def fuzzy_ago_from_now(delta_or_time)
      if delta_or_time.is_a? Integer
        FuzzyTimeAgo.fuzzy_ago(Time.now - delta_or_time)
      elsif delta_or_time.is_a?(Time) || delta_or_time.is_a?(Date)
        FuzzyTimeAgo.fuzzy_ago(delta_or_time)
      end
    end

    it "returns 'less than a minute ago' for 0-59 seconds" do
      expect(fuzzy_ago_from_now(0)).to eq('less than a minute ago')
      expect(fuzzy_ago_from_now(30)).to eq('less than a minute ago')
      expect(fuzzy_ago_from_now(59)).to eq('less than a minute ago')
    end

    it "returns 'about a minute ago' for 60-119 seconds" do
      expect(fuzzy_ago_from_now(60)).to eq('about a minute ago')
      expect(fuzzy_ago_from_now(90)).to eq('about a minute ago')
      expect(fuzzy_ago_from_now(119)).to eq('about a minute ago')
    end

    it 'returns minutes for 2+ minutes' do
      expect(fuzzy_ago_from_now(120)).to eq('2 minutes ago')
      expect(fuzzy_ago_from_now(300)).to eq('5 minutes ago')
      expect(fuzzy_ago_from_now(60 * MINUTES - 1)).to eq('59 minutes ago')
    end

    it "returns 'about an hour ago' for 1-2 hours" do
      expect(fuzzy_ago_from_now(60 * MINUTES)).to eq('about an hour ago')
      expect(fuzzy_ago_from_now(120 * MINUTES - 1)).to eq('about an hour ago')
    end

    it 'returns hours for 2+ hours' do
      expect(fuzzy_ago_from_now(120 * MINUTES)).to eq('about 2 hours ago')
      expect(fuzzy_ago_from_now(180 * MINUTES)).to eq('about 3 hours ago')
      expect(fuzzy_ago_from_now(24 * HOURS - 1)).to eq('about 23 hours ago')
    end

    it "returns 'a day ago' for 1-2 days" do
      expect(fuzzy_ago_from_now(24 * HOURS)).to eq('a day ago')
      expect(fuzzy_ago_from_now(48 * HOURS - 1)).to eq('a day ago')
    end

    it 'returns days for 2+ days' do
      expect(fuzzy_ago_from_now(2 * DAYS)).to eq('2 days ago')
      expect(fuzzy_ago_from_now(3 * DAYS)).to eq('3 days ago')
      expect(fuzzy_ago_from_now(7 * DAYS - 1)).to eq('6 days ago')
    end

    it "returns 'about a week ago' for 1-2 weeks" do
      expect(fuzzy_ago_from_now(7 * DAYS)).to eq('about a week ago')
      expect(fuzzy_ago_from_now(14 * DAYS - 1)).to eq('about a week ago')
    end

    it 'returns weeks for 2+ weeks' do
      expect(fuzzy_ago_from_now(14 * DAYS)).to eq('about 2 weeks ago')
      expect(fuzzy_ago_from_now(21 * DAYS)).to eq('about 3 weeks ago')
    end

    it "returns 'about 4 weeks ago' for 4 weeks-1 month" do
      (28...31).each do |delta|
        expect(fuzzy_ago_from_now(delta * DAYS)).to eq('about 4 weeks ago')
      end
    end

    it "returns 'about a month ago' for 4 weeks in a non-leap-year February" do
      Timecop.freeze Time.new(2025, 0o3, 0o1, 12, 0, 0)
      expect(fuzzy_ago_from_now(28 * DAYS)).to eq('about a month ago')
    end

    it "returns 'about a month ago' for 1-2 months" do
      expect(fuzzy_ago_from_now(today.prev_month)).to eq('about a month ago')
      expect(fuzzy_ago_from_now(today.prev_month(2) + 1)).to eq('about a month ago')
    end

    it "returns 'about 2 months ago' for 2-3 months" do
      expect(fuzzy_ago_from_now(today.prev_month(2))).to eq('about 2 months ago')
      expect(fuzzy_ago_from_now(today.prev_month(3) + 1)).to eq('about 2 months ago')
    end

    it 'returns months for 3+ months' do
      (3...12).each do |month|
        expect(fuzzy_ago_from_now(today.prev_month(month))).to eq("#{month} months ago")
      end
    end

    it "returns 'about a year ago' for 1 year to 1 year 3 months" do
      (0...3).each do |extra_months|
        expect(fuzzy_ago_from_now(today.prev_year.prev_month(extra_months))).to eq('about a year ago')
      end
      expect(fuzzy_ago_from_now(today.prev_year.prev_month(3) + 1)).to eq('about a year ago')
    end

    it "returns 'over a year ago' for 1 year 3 months to 1 year 9 months" do
      (3...9).each do |extra_months|
        expect(fuzzy_ago_from_now(today.prev_year.prev_month(extra_months))).to eq('over a year ago')
      end
      expect(fuzzy_ago_from_now(today.prev_year.prev_month(9) + 1)).to eq('over a year ago')
    end

    it "returns 'almost n years ago' for n-1 year 9 months to n years (1 < n <= 10)" do
      (2..10).each do |years|
        (9...12).each do |extra_months|
          expect(fuzzy_ago_from_now(today.prev_year(years - 1).prev_month(extra_months))).to eq("almost #{years} years ago")
        end
        expect(fuzzy_ago_from_now(today.prev_year(years - 1).prev_month(12) + 1)).to eq("almost #{years} years ago")
      end
    end

    it "returns 'about n years ago' for n years to n years 3 months (1 < n <= 10)" do
      (2..10).each do |years|
        (0...3).each do |extra_months|
          expect(fuzzy_ago_from_now(today.prev_year(years).prev_month(extra_months))).to eq("about #{years} years ago")
        end
        expect(fuzzy_ago_from_now(today.prev_year(years).prev_month(3) + 1)).to eq("about #{years} years ago")
      end
    end

    it "returns 'over n years ago' for n year 3 months to n years 9 months (1 < n <= 10)" do
      (2..10).each do |years|
        (3...9).each do |extra_months|
          expect(fuzzy_ago_from_now(today.prev_year(years).prev_month(extra_months))).to eq("over #{years} years ago")
        end
        expect(fuzzy_ago_from_now(today.prev_year(years).prev_month(9) + 1)).to eq("over #{years} years ago")
      end
    end

    it 'returns years for 10+ years' do
      expect(described_class.fuzzy_ago(today.prev_year(10))).to eq('about 10 years ago')
      expect(described_class.fuzzy_ago(today.prev_year(20))).to eq('about 20 years ago')
      expect(described_class.fuzzy_ago(today.prev_year(50))).to eq('about 50 years ago')
    end
  end

  context 'when given invalid input' do
    it 'raises an ArgumentError for unsupported types' do
      expect { described_class.fuzzy_ago('invalid') }.to raise_error(ArgumentError, 'Expected Time or Date object')
    end
  end

  describe 'Time#fuzzy_ago' do
    it 'adds a convenience method to Time objects' do
      past_time = Time.now - 30 * MINUTES
      expect(past_time.fuzzy_ago).to eq('30 minutes ago')
    end
  end
end
