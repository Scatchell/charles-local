require_relative 'ssid_obtainer'
require_relative 'ssid_constants'
require_relative 'day'
require_relative 'data_store'
require 'time'

class Charles
  include SSIDConstants
  DEFAULT_DAYS_LOCATION = File.expand_path('../../data/days.dys', __FILE__)
  attr_accessor :days

  def initialize(days = {}, data_store=DataStore.new(DEFAULT_DAYS_LOCATION))
    @check_time_in_seconds = 1
    @days = days
    @count = 5
    @infinite = true
    @data_store = data_store
  end

  def at_work
    ssid = SSIDObtainer.current_ssid
    if WORK_SSID.is_a? Array
      WORK_SSID.include? ssid
    else
      WORK_SSID == ssid
    end
  end

  def create_or_end_day
    now = Time.now

    if at_work
      @days[now.to_date] ||= Day.new now
      @days[now.to_date].end now
      @data_store.save_days @days
    end
  end

  def go
    puts 'Charles is watching...'
    if @days
      puts 'Current days: '

      weeks = days_to_weeks @days

      display_days_by_week weeks
    else
      @days = {}
    end

    begin_watching

  end

  def begin_watching
    while true
      if @count > 0
        create_or_end_day
        sleep @check_time_in_seconds
        decrement_count
      else
        puts 'Charles is done watching...'
        display_days_by_week days_to_weeks(@days)
        exit!
      end
    end
  end

  def decrement_count
    unless @infinite
      @count -= 1
    end
  end

  def display_days_by_week(weeks)
    weeks.each do |week|
      first_day_of_week = beg_of_week week[0].start_time
      last_day_of_week = end_of_week week[0].start_time

      puts 'Week: ' + first_day_of_week.strftime('%A') + ', ' + first_day_of_week.month.to_s + '/' + first_day_of_week.day.to_s + " - " + last_day_of_week.month.to_s + '/' + last_day_of_week.day.to_s
      week.each do |day|
        puts day.start_time.strftime('%A') + ', ' + day.start_time.month.to_s + '/' + day.start_time.day.to_s + ': ' + day.time_worked.to_s
      end
    end
  end

  def beg_of_week first_day_start_time
    first_day_start_time - first_day_start_time.wday * (24*60*60)
  end

  def end_of_week first_day_start_time
    beg_of_week(first_day_start_time) + (7*24*60*60)
  end

  def days_to_weeks days
    weeks = days.values.group_by do |day|
      day.start_time.strftime('%U')
    end

    weeks.values
  end
end
