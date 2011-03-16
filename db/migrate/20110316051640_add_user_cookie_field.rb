class AddUserCookieField < ActiveRecord::Migration
  def self.up
    add_column :users, :cookie, :string, :limit => 64
    add_index :users, :cookie
  end

  def self.down
    remove_column :users, :cookie
    remove_index :users, :cookie
  end
end
