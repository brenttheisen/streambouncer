class Bounce < ActiveRecord::Base
  belongs_to :follow
  
  def perform
    return unless self.follow.active_bounce_id = self.id
    
    self.reload
    
    follow = self.follow
    
    user = follow.user
    twitter_user = follow.twitter_user

    logger.info "Refollowing #{follow.twitter_user.username} (#{follow.twitter_user.twitter_id}) for #{user.twitter_user.username} (#{user.twitter_user.twitter_id})"
    client = user.twitter_client
    response = client.friend(twitter_user.twitter_id)
    logger.info "Refollow response... #{response.to_json}"
    
    follow.active_bounce_id = nil
    follow.save 
    
    self.executed_at = Time.now
    self.save
  end
end
