class User < ActiveRecord::Base
  has_many :songs
  has_many :upvotes

  # validates :email, presence: true
  # validates :password, presence: true

  def already_voted?(song)
    !!self.upvotes.find_by(song_id: song.id)
  end
end