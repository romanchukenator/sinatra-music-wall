class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :song

  validates :user, presence: true
  validates :song, presence: true
  validates :song_id, uniqueness: { scope: :user_id }


  validates :user_review, { length: { maximum: 140, minimum: 3  } }
  validates :user_rating, presence: true, inclusion: { in: 1..5, message: "must be between 1 and 5" }



end
