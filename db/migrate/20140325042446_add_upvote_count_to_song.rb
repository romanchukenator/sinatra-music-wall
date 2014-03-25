class AddUpvoteCountToSong < ActiveRecord::Migration
  def change
    add_column :songs, :upvote_count, :integer, :default => 0
  end
end
