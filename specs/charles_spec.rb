require 'rspec'
require 'time'
require_relative '../src/ssid_constants'
require_relative '../src/charles'

WORK_SSID = 'twdata'
SPEC_DAYS_DATA_LOCATION = File.expand_path('../spec_data/days.dys', __FILE__)

describe "Should control TIME!" do
  let(:spec_data_store) { DataStore.new(SPEC_DAYS_DATA_LOCATION) }
  let(:charles) { Charles.new({}, spec_data_store) }

  beginning_of_day = Time.parse('2001-01-11 11:11:11')

  it 'should correctly identify the user is on the work network' do
    SSIDObtainer.stub(:current_ssid).and_return(WORK_SSID)
    charles.at_work.should == true
  end

  it 'should create a new day with the current time if one does not exist' do
    SSIDObtainer.stub(:current_ssid).and_return(WORK_SSID)
    Time.stub(:now).and_return(beginning_of_day)
    charles.create_or_end_day

    charles.days.size.should == 1

    charles.days[beginning_of_day.to_date].start_time.should == beginning_of_day
  end

  it 'should not create a new day if one already exists' do
    SSIDObtainer.stub(:current_ssid).and_return(WORK_SSID)
    charles.create_or_end_day
    charles.create_or_end_day
    #assert start time
    charles.days.size.should == 1
  end

  it 'should not increment the day time when the user is logged off the network' do
    SSIDObtainer.stub(:current_ssid).and_return('OFF_NETWORK')
    middle_of_day = Time.parse('2001-01-11 12:12:12')
    end_of_day = Time.parse('2001-01-11 20:00:00')

    Time.stub(:now).and_return(end_of_day)

    current_day = Day.new(beginning_of_day, middle_of_day)

    charles = Charles.new({beginning_of_day.to_date => current_day}, spec_data_store)

    charles.create_or_end_day

    charles.days.size.should == 1

    charles.days[beginning_of_day.to_date].start_time.should == beginning_of_day
    charles.days[beginning_of_day.to_date].end_time.should == middle_of_day
  end

  it 'should increment the day time when the user is still logged on the network' do
    SSIDObtainer.stub(:current_ssid).and_return(WORK_SSID)
    middle_of_day = Time.parse('2001-01-11 12:12:12')
    end_of_day = Time.parse('2001-01-11 20:00:00')

    Time.stub(:now).and_return(end_of_day)

    current_day = Day.new(beginning_of_day, middle_of_day)

    charles = Charles.new({beginning_of_day.to_date => current_day}, spec_data_store)

    charles.create_or_end_day

    charles.days.size.should == 1

    charles.days[beginning_of_day.to_date].start_time.should == beginning_of_day
    charles.days[beginning_of_day.to_date].end_time.should == end_of_day
  end

  it 'should start a new day when the user logs on the network and no day already exists' do
    SSIDObtainer.stub(:current_ssid).and_return(WORK_SSID)
    middle_of_day = Time.parse('2001-01-11 12:12:12')
    next_day = Time.parse('2001-02-11 12:12:12')
    end_of_next_day = Time.parse('2001-02-11 17:12:12')

    Time.stub(:now).and_return(next_day, end_of_next_day)

    current_day = Day.new(beginning_of_day, middle_of_day)

    charles = Charles.new({beginning_of_day.to_date => current_day}, spec_data_store)

    charles.create_or_end_day

    charles.create_or_end_day

    charles.days.size.should == 2

    charles.days[beginning_of_day.to_date].start_time.should == beginning_of_day
    charles.days[beginning_of_day.to_date].end_time.should == middle_of_day

    charles.days[next_day.to_date].start_time.should == next_day
    charles.days[next_day.to_date].end_time.should == end_of_next_day
  end

  it 'should separate days into weeks' do
    days = {}
    days["day1"] = Day.new(Time.parse('2001-01-11 12:12:12'))
    days["day2"] = Day.new(Time.parse('2001-01-12 12:12:12'))
    days["day3"] = Day.new(Time.parse('2001-01-18 12:12:12'))
    days["day4"] = Day.new(Time.parse('2001-01-25 12:12:12'))

    weeks = charles.days_to_weeks(days)
    weeks.size.should == 3
    weeks[0][0].start_time.day.should == 11
    weeks[0][1].start_time.day.should == 12
    weeks[1][0].start_time.day.should == 18
    weeks[2][0].start_time.day.should == 25
  end

  it 'should calculate first day of a week' do
    day = Day.new(Time.parse('2013-06-13 12:12:12'))

    charles.beg_of_week(day.start_time).day.should == 9
  end
end
