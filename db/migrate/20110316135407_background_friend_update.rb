class BackgroundFriendUpdate < ActiveRecord::Migration
  def self.up
    add_column :users, :update_friends_progress, :integer
    add_column :users, :updated_friends_at, :datetime
  end

  def self.down
    remove_column :users, :updated_friends_at
    remove_column :users, :update_friends_progress
  end
end
