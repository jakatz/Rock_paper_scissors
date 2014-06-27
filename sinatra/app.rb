require 'sinatra'
require 'pry-byebug'
require_relative "../lib/rps-manager.rb"

enable :sessions

set :bind, '0.0.0.0'

get '/sign_in' do
  erb :sign_in
end

post '/user/friends' do
  u = RPS::Sign_in.run(params)

  if u.success?
    session[:username] = u.player.username
    erb :friends
  else
    erb :sign_in
  end
end

post '/user/friends/new' do
  u = RPS::Create_player.run(params)
  if u.success?
    session[:username] = u.player.username
    erb :friends
  else
    erb :sign_in
  end
end

get '/user/game' do
  @player1 = RPS.orm.select_player( session[:username] )
  @games = RPS.orm.list_games_by_player( @player1.id )
  @active_games = @games.select{ |game| game.winner == -1 }
  @inactive_games = @games.select{ |game| game.winner != -1 }
  unless params[:move].nil?
    @game = RPS.orm.select_game( params[:game_id] )
    if game.player1 = @player1.id
      @round = RPS.orm.initialize_round(params["game_id"], params["move"])
    else
      @round = RPS.orm.add_move( @game.id, @player1.id )
    end
  end
  erb :game
end

get '/user/friends' do
    erb :friends
end

get '/user/game/first_move' do
    @player1 = RPS.orm.select_player( session[:username] )
    @player2 = RPS.orm.select_player( params["player2"] )
    @game = RPS.orm.add_game(@player1.id, @player2.id)
    RPS.orm.
  erb :gameplay
end

get '/user/game/second_move' do
    @player2 = RPS.orm.select_player( session[:username] )
    @player1 = RPS.orm.select_player( params["player2"] )
  erb :gameplay
end

get '/user/game/review'do
  erb :game
end


