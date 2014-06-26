require 'sinatra'
require_relative "../lib/rps-manager.rb"

enable :sessions

set :bind, '0.0.0.0'

get '/sign_in' do
  erb :sign_in
end

post '/sign_in' do
  u = RPS::Sign_in.run(params)

  if u.success?
    session[:username] = u.player.username
    erb :friends
  else
    erb :sign_in
  end
end

get '/friends' do
  erb :friends
end

post '/create_user' do
  u = RPS::Create_player.run(params)
  if u.success?
    session[:username] = u.player.username
    erb :friends
  else
    erb :sign_in
  end
end
