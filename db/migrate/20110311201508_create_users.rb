class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :twitter_username
      t.string :twitter_access_token
      t.string :twitter_access_token_secret
      t.timestamps
    end
    add_index :users, :twitter_username, :unique => true
  end

  def self.down
    drop_table :users
  end
end
