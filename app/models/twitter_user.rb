class TwitterUser < ActiveRecord::Base
  
  def update_from_response(response)
    self.twitter_id = response['id']
    self.username = response['screen_name']
    self.name = response['name']
    self.picture_url = response['profile_image_url']
      
    self
  end
end
