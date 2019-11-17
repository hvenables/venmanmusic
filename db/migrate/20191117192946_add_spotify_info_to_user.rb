class AddSpotifyInfoToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :followers, :integer, default: 0
    add_column :users, :image, :text
  end
end
