class CreateBounces < ActiveRecord::Migration
  def self.up
    create_table :bounces do |t|
      t.boolean :active, :default => true
      t.integer :user_id, :null => false
      t.integer :twitter_user_id, :null => false
      t.datetime :expire_at
      t.timestamps
    end
  end

  def self.down
    drop_table :bounces
  end
end
