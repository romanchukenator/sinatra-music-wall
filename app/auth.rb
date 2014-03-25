# ========================
# User shizz
# ========================

get '/sign_up' do
  @user = User.new
  erb :'sign_up'
end 

post '/sign_up' do
  @user = User.new(
    email: params[:email],
    password: params[:password]
    )

  if @user.save
    session[:user_id] = @user.id
    redirect '/'
  else
    erb :'sign_up'
  end
end

get '/log_in' do
  @user = User.all
  erb :'log_in'
end

post '/log_in' do
  @user = User.find_by( 
    email: params[:email], 
    password: params[:password]
    )
  
  if @user
    session[:user_id] = @user.id
    redirect '/'
  else
    erb :'log_in'
  end
end

get '/log_out' do
  session[:user_id] = nil
  redirect '/'
end