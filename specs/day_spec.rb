require 'rspec'
require_relative '../src/day'

describe Day do

  it 'should calculate time between start and end time' do
    before = Time.parse('2001-01-11 12:12:12')
    after = before + (60 * 60 * 90)
    day = Day.new before, after

    day.time_worked.should == 90
  end

  it 'should calculate time between start and end time when seconds dont divide evenly' do
    before = Time.parse('2001-01-11 12:12:12')
    after = before + ((60 * 60 * 90) + 12)
    day = Day.new before, after

    day.time_worked.should == 90
  end
end
