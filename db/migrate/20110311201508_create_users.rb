class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :twitter_id, :null => false
      t.string :twitter_username, :null => false
      t.string :twitter_access_token, :null => false
      t.string :twitter_access_token_secret, :null => false
      t.timestamps
    end
    add_index :users, :twitter_username, :unique => true
  end

  def self.down
    drop_table :users
  end
end
