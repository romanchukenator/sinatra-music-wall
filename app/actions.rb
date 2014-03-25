helpers do
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end

# Homepage (Root path)
get '/' do
  erb :index
end

get '/songs' do
  @songs = Song.all
  erb :'songs/index'
end

get '/songs/new' do
  @song = Song.new
  erb :'songs/new'
end

get '/songs/:id' do
  @song = Song.find params[:id]
  erb :'songs/song_details'
end

get 'songs/:artist' do
  @songs = Song.find params[:artist]
  erb :"songs/artist"
end

post '/songs' do
  @song = Song.new(
    song_title: params[:song_title],
    artist: params[:artist],
    genre: params[:genre],
    url: params[:url],
    user_id: current_user.id
    )

  if @song.save
    redirect '/songs'
  else
    erb :'songs/new'
  end
end

post '/songs/like/:song_id/:user_id' do
  Upvote.create(
    song_id: params[:song_id],
    user_id: params[:user_id]
    )

  vote = Song.find(params[:song_id]).upvote_count
  vote += 1
  Song.find(params[:song_id]).update(
    upvote_count: vote
    )

  puts "Like button working"
  redirect '/songs'
end

post '/songs/unlike/:song_id/:user_id' do
  vote_id = Upvote.find_by(
    song_id: params[:song_id],
    user_id: params[:user_id]
    ).id

  Upvote.delete(vote_id)

  vote = Song.find(params[:song_id]).upvote_count
  vote -= 1
  Song.find(params[:song_id]).update(
    upvote_count: vote
    )

  puts "Like button working"
  redirect '/songs'
end


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














