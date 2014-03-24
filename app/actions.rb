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

post '/songs' do
  @song = Song.new(
    song_title: params[:song_title],
    artist: params[:artist],
    url: params[:url],
    )

  @song.save
  redirect '/songs'
end

# rake db:create_migration NAME=name_of_migration