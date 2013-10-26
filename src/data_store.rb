require 'yaml'
class DataStore
  attr_accessor :yaml_data
  @file_name = 'data/days.dys'

  def self.save_days(days)
    File.open(@file_name, 'w') do |f|
      f.write YAML::dump(days)
    end
  end

  def self.load_days
    YAML::load(File.open(@file_name).read)
  end

end