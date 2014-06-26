require 'sinatra'
require 'pry-byebug'
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

post '/create_user' do
  u = RPS::Create_player.run(params)
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

get '/game' do
  puts params
  puts session
  binding.pry
  @player1 = RPS.orm.select_player( session[:username] )
  @player2 = RPS.orm.select_player( params["player2"] )
  RPS.orm.add_game(player1.id, player2.id)
  @games = RPS.orm.select_games_by_player( session[:username] )
  erb :game
end




post'/gameplay' do
  u = params

end

post '/scissors' do
  erb :scissors
end

post '/paper' do
  erb :paper
end

post '/rock' do
  erb :rock
  # RPS.orm.initialize_round('r'
end

