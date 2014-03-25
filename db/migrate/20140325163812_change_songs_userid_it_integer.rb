class ChangeSongsUseridItInteger < ActiveRecord::Migration
  def change
    change_column(:songs, :user_id, :integer)
  end
end