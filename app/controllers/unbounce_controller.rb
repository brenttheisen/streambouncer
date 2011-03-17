class UnbounceController < ApplicationController
  def index
    @follow = Follow.where([ 'id=? and user_id=?', params[:id], @logged_in_user.id]).first
    
    bounce = @follow.bounce
    unless bounce.nil?
      bounce.canceled_at = Time.now
      bounce.active = false
      bounce.save
    end

    if params[:f].nil? || params[:f] == '1'
      logger.info "Refollowing #{@follow.twitter_user.username} (#{@follow.twitter_user.twitter_id}) for #{@logged_in_user.twitter_user.username} (#{@logged_in_user.twitter_user.twitter_id})"
      twitter_client = @logged_in_user.twitter_client
      response = twitter_client.friend(@follow.twitter_user.twitter_id)
      logger.info "Refollow response... #{response.to_json}"
    else
      logger.info "Canceling bounce without re-follow: #{@follow.twitter_user.username} (#{@follow.twitter_user.twitter_id}) for #{@logged_in_user.twitter_user.username} (#{@logged_in_user.twitter_user.twitter_id})"
    end    
    
    @follow.bounce = nil
    @follow.save
  end
end
