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
  @songs = Song.order("upvote_count DESC").all
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

  redirect '/songs'
end


# =====================
# Posting Reviews
# =====================

post '/reviews/:song_id' do
  @review = Review.new(
    user_review: params[:user_review],
    user_rating: params[:user_rating],
    song_id: params[:song_id],
    user_id: current_user.id,
    )

  if @review.save
    # redirect '/songs/<%= @review.song_id %>'
    redirect '/songs/' + params[:song_id]
  else
    erb :'/songs'
  end
end