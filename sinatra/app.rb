require 'sinatra'

enable :sessions

set :bind, '0.0.0.0'

get '/game' do
  erb :game
end

post '/sign_in' do
  puts params
  u = User.sign_in(params[:username], params[:password])

  if u
    session[:user_id] = u.user_id
  end
end
