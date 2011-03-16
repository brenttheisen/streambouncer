class BounceController < ApplicationController
  def index
    @follow = Follow.where([ 'id=? and user_id=?', params[:id], @logged_in_user.id]).first
    @bounce = @follow.bounce
    @bounce ||= Bounce.new
    
    client = TwitterOAuth::Client.new(
      :consumer_key => StreamBouncer::Application.config['twitter_consumer_key'],
      :consumer_secret => StreamBouncer::Application.config['twitter_consumer_secret'],
      :token => @logged_in_user.twitter_access_token, 
      :secret => @logged_in_user.twitter_access_token_secret
    )
    client.unfriend(@follow.twitter_user.twitter_id)
    
    @bounce.take_action_at = 5.minutes.from_now
    # @bounce.take_action_at = Time.at(params[:t].to_i)
    @bounce.save
    
    Delayed::Job.enqueue(@bounce, @bounce.take_action_at)

    @follow.bounce = @bounce
    @follow.save
  end
end
