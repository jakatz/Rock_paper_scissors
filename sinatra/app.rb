require 'sinatra'

enable :sessions

set :bind, '0.0.0.0'

get '/sign_in' do
  erb :sign_in
end

post '/sign_in' do
  puts params
  u = RPS::Sign_in.run(params)

  if u
    session[:username] = u.username
  end
end

get '/friends' do
  erb :friends
end
