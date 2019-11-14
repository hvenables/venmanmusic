class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.belongs_to :sender, foreign_key: { to_table: :users }
      t.belongs_to :recipient, foreign_key: { to_table: :users }
      t.belongs_to :playlist
      t.text :message
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
