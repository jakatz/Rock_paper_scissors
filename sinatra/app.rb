require 'sinatra'

enable :sessions

set :bind, '0.0.0.0'


post '/sign_in' do
  puts params
  u = User.sign_in(params[:username], params[:password])

  if u
    session[:user_id] = u.user_id
  end

get '/friends' do
  erb :friends
end
