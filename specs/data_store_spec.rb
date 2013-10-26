require 'rspec'
require_relative '../src/data_store'

describe DataStore do

  it 'should serialize data' do
    days = {}
    now = Time.now
    later = Time.now + (60*60*24*2)
    day_new = Day.new(now)
    day_later = Day.new(later)

    days[now.to_date] = day_new
    days[now.to_date].end(now + 600)
    days[later.to_date] = day_later
    days[later.to_date].end(later + 600)

    DataStore.save_days(days)
    DataStore.load_days[now.to_date].start_time.should == day_new.start_time
    DataStore.load_days[now.to_date].end_time.should == day_new.end_time
  end
end