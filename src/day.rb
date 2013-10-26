class Day
  attr_accessor :start_time, :end_time
  def initialize current_time, end_time = nil
    @start_time = current_time
    @end_time = end_time
  end

  def end ending_time
    @end_time = ending_time
  end

  def time_worked
    minutes = ((@end_time - @start_time)/60)
    (minutes/60).round(2)
  end
end
