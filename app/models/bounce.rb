class Bounce < ActiveRecord::Base
  has_one :follow
  
  def perform
    return unless self.active
    
    self.reload
    
    follow = self.follow
    
    user = follow.user
    twitter_user = follow.twitter_user

    client = user.twitter_client
    client.friend(twitter_user.twitter_id)
    
    follow.bounce_id = nil
    follow.save 
    
    self.active = false
    self.executed_at Time.now
    self.follow = nil
    self.save
  end
end
