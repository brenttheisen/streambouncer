class CreateTwitterUsers < ActiveRecord::Migration
  def self.up
    create_table :twitter_users do |t|
      t.string :twitter_id, :null => false
      t.string :username, :null => false
      t.string :name, :null => false
      t.timestamps
    end
    add_index :twitter_users, :twitter_id, :unique => true
  end

  def self.down
    drop_table :twitter_users
  end
end
