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
post '/songs/:song_id/upvotes' do
  @song = Song.find params[:song_id]
  @upvote = @song.upvotes.create(user: current_user)
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
    redirect '/songs/' + params[:song_id]
  else
    erb :'/songs'
  end
end

get '/delete/:song_id' do
    Review.find_by(
      song_id: params[:song_id],
      user_id: current_user.id
      ).delete
    redirect '/songs/' + params[:song_id]
end
