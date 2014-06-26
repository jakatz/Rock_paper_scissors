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
  @player1 = RPS.orm.select_player( session[:username] )
  @player2 = RPS.orm.select_player( params["player2"] )
  RPS.orm.add_game(@player1.id, @player2.id)

  @games = RPS.orm.list_games_by_player( @player1.id )
  @active_games = @games.select{ |game| game.winner == -1 }
  @inactive_games = @games.select{ |game| game.winner != -1 }
  erb :game
end



