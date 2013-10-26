require 'rspec'
require_relative '../src/data_store'

describe DataStore do

  SPEC_DAYS_DATA_LOCATION = File.expand_path('../spec_data/days.dys', __FILE__)

  it 'should serialize spec_data' do
    days = {}
    now = Time.now
    later = Time.now + (60*60*24*2)
    day_new = Day.new(now)
    day_later = Day.new(later)

    days[now.to_date] = day_new
    days[now.to_date].end(now + 600)
    days[later.to_date] = day_later
    days[later.to_date].end(later + 600)

    data_store = DataStore.new(SPEC_DAYS_DATA_LOCATION)
    data_store.save_days(days)
    data_store.load_days[now.to_date].start_time.should == day_new.start_time
    data_store.load_days[now.to_date].end_time.should == day_new.end_time
  end
end