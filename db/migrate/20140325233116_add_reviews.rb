class AddReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :user_review
      t.integer :user_rating
      t.string :user_id
      t.string :song_id

      t.timestamps
    end
  end
end