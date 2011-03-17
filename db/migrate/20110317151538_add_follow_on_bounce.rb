class AddFollowOnBounce < ActiveRecord::Migration
  def self.up
    add_column :bounces, :follow_id, :integer, :null => false, :after => :id
  end

  def self.down
    remove_column :bounces, :follow_id
  end
end
