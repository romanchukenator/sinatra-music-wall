class Song < ActiveRecord::Base
  belongs_to :user
  has_many :upvotes
  has_many :reviews

  validates   :song_title, 
              :artist, 
                presence: true,
                length: { minimum: 2 }
end