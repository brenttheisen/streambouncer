class TwitterUser < ActiveRecord::Base
  
  has_one :user
  
  def update_from_response(response)
    self.twitter_id = response['id']
    self.username = response['screen_name']
    self.name = response['name']
    self.picture_url = response['profile_image_url']
    
    unless response['status'].nil?
      self.last_tweet = response['status']['text']
      self.last_tweet_at = response['status']['created_at']
    end
    
    self.friends_count = response['friends_count']
    self
  end
end
