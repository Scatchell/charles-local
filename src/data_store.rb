require 'yaml'
class DataStore
  attr_accessor :yaml_data

  def initialize file_location
    @days_file_location = file_location
  end

  def save_days(days)
    File.open(@days_file_location, 'w') do |f|
      f.write YAML::dump(days)
    end
  end

  def load_days
    YAML::load(File.open(@days_file_location).read)
  end

end
