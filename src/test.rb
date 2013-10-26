require 'sinatra'


class Charles < Sinatra::Base
    configure do
        set :count, 0
    end

    get '/' do
        "You have loaded the page #{settings.count+=1} times"
    end

    get '/touch' do
        settings.count += 1
    end
end

Charles.run!
