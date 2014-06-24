require 'sinatra'

set :bind, '0.0.0.0'

get '/game' do
  erb :sign_in
end


