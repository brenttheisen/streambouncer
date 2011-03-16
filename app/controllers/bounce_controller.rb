class BounceController < ApplicationController
  def index
    @follow = Follow.where([ 'id=? and user_id=?', params[:id], @logged_in_user.id]).first
    @bounce = @follow.bounce
    @bounce ||= Bounce.new
    
    logger.info "Unfollowing #{@follow.twitter_user.username} (#{@follow.twitter_user.twitter_id}) for #{@logged_in_user.twitter_user.username} (#{@logged_in_user.twitter_user.twitter_id})"
    client = @logged_in_user.twitter_client
    client.unfriend(@follow.twitter_user.twitter_id)
    
    # @bounce.take_action_at = 5.minutes.from_now.getutc
    @bounce.take_action_at = Time.at(params[:t].to_i)
    @bounce.save
    
    Delayed::Job.enqueue(@bounce, :run_at => @bounce.take_action_at)

    @follow.bounce = @bounce
    @follow.save
  end
end
