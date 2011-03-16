class Bounce < ActiveRecord::Base
  has_one :follow
  
  def perform
    return unless self.active
    
    self.reload
    
    follow = self.follow
    user = follow.user
    client = TwitterOAuth::Client.new(
      :consumer_key => StreamBouncer::Application.config['twitter_consumer_key'],
      :consumer_secret => StreamBouncer::Application.config['twitter_consumer_secret'],
      :token => user.twitter_access_token, 
      :secret => user.twitter_access_token_secret
    )
    
    twitter_user = follow.twitter_user
    client.friend(twitter_user.twitter_id)
    
    follow.bounce_id = nil
    follow.save 
    
    self.active = false
    self.executed_at Time.now
    self.follow = nil
    self.save
  end
end
