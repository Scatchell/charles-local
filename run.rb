require_relative 'src/charles'

puts Charles.new(DataStore.load_days).go

#todo how to stop this thing from user input?