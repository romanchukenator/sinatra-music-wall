class Song < ActiveRecord::Base
  belongs_to :user
  has_many :upvotes

  validates   :song_title, 
              :artist, 
                presence: true,
                length: { minimum: 2 }
end