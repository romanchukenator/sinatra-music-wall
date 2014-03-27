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
  # SELECT * FROM songs ORDER BY songs.upvote_count
  @songs = Song.order(:upvote_count)
  if params[:user_id].present? # not nil or empty string!
    @songs = @songs.where(user_id: params[:user_id])
  end
  if params[:min_votes].present? # not nil or empty string!
    @songs = @songs.where('upvote_count >= ?', params[:min_votes])
  end
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
  @song = current_user.songs.new(
    song_title: params[:song_title],
    artist: params[:artist],
    genre: params[:genre],
    url: params[:url]
  )

  if @song.save
    redirect '/songs'
  else
    erb :'songs/new'
  end
end

# # Update the upvote
# post '/songs/:song_id/upvotes/:id' do
#   @song = Song.find params[:song_id]
#   @upvote = current_user.upvotes.where(song_id: @song.id).find params[:id]
# end

# Create the upvote
post '/songs/:song_id/upvote' do
  @song = Song.find params[:song_id]
  @upvote = @song.upvotes.create(user: current_user)
  redirect '/songs'
end

delete '/songs/:song_id/upvote' do
  @song = Song.find params[:song_id]
  @upvote = current_user.upvotes.find_by(song_id: @song.id)
  @upvote.destroy
  redirect '/songs'
end


# =====================
# Posting Reviews
# =====================

post '/songs/:song_id/review' do
  @song = Song.find params[:song_id]
  current_user.reviews.new(
    song: @song,
    user_review: params[:user_review],
    user_rating: params[:user_rating]
  )

  if @review.save
    redirect '/songs/' + params[:song_id]
  else
    erb :'/songs'
  end
end

delete '/songs/:song_id/review' do
  @song = Song.find params[:song_id]
  @review = current_user.reviews.find_by(song_id: @song.id)
  redirect '/songs/' + params[:song_id]
end
