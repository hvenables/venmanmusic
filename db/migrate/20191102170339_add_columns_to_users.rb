class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :uid, :string
    add_column :users, :country_code, :string
    add_column :users, :href, :string
  end
end
