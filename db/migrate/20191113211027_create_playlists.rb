class CreatePlaylists < ActiveRecord::Migration[6.0]
  def change
    create_table :playlists do |t|
      t.string :uid
      t.string :name
      t.string :href
      t.belongs_to :user

      t.timestamps
    end
  end
end
