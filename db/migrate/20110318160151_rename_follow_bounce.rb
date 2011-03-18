class RenameFollowBounce < ActiveRecord::Migration
  def self.up
    rename_column :follows, :bounce_id, :active_bounce_id
    remove_column :bounces, :active
  end

  def self.down
    rename_column :follows, :active_bounce_id, :bounce_id
    add_column :bounces, :active, :boolean, :default => true
  end
end
