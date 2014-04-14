require_relative 'src/charles'

Charles.new(DataStore.new('data/days.dys').load_days).go

#todo how to stop this thing from user input?
