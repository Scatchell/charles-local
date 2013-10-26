require_relative 'ssid_obtainer'
require_relative 'constants'
require_relative 'day'
require_relative 'data_store'
require 'time'

class Charles
    include Constants
    attr_accessor :days

    def initialize(days = {})
        #in seconds
        @check_time = 1
        @days = days
        @count = 5
        @infinite = true
    end

    def at_work
        ssid = SSIDObtainer.obtain
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
            DataStore.save_days @days
            #else
            #  puts 'Off network detected @ ' + now.to_s
        end
    end

    def go
        puts 'Charles is watching...'
        if @days
            puts 'Current days: '

            weeks = days_to_weeks @days

            weeks.each do |week|
                first_day_of_week = beg_of_week week[0].start_time
                last_day_of_week = end_of_week week[0].start_time

                puts "Week: " + first_day_of_week.strftime("%A") + ', ' + first_day_of_week.month.to_s + '/' + first_day_of_week.day.to_s + " - " + last_day_of_week.month.to_s + '/' + last_day_of_week.day.to_s
                week.each do |day|
                    puts day.start_time.strftime("%A") + ', ' + day.start_time.month.to_s + '/' + day.start_time.day.to_s + ': ' + day.time_worked.to_s
                end
            end
        else
            @days = {}
        end

        while true
            if @count > 0
                create_or_end_day
                sleep @check_time
                unless @infinite
                    @count -= 1
                end
            else
                p @days
                exit!
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
            day.start_time.strftime("%U")
        end

        weeks.values
    end
end
