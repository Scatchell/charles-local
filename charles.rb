require_relative 'src/charles'

Charles.new(DataStore.new('/Users/ThoughtWorks/sideProjects/Ruby/Charles/data/days.dys').load_days).go
