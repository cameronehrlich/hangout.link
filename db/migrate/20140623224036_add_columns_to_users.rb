class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :name, :string
    add_column :users, :subdomain, :string
    add_column :users, :image, :string
    add_column :users, :stripe_token, :string
    add_column :users, :stripe_id, :string
    add_column :users, :referred_by, :string
  end
end
