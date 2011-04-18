class CreateTwitterBots < ActiveRecord::Migration
  def self.up
    create_table :twitter_bots do |t|
      t.integer   "user_id"                     
      t.column   :last_direct_message_id, :bigint, :unsigned => true
      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_bots
  end
end
