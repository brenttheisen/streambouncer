class BounceController < ApplicationController
  def index
    @follow = Follow.where([ 'id=? and user_id=?', params[:id], @logged_in_user.id]).first
    @bounce = @follow.bounce
    @bounce ||= Bounce.new
    
    # Take action on the bounce in 5 minutes
    @bounce.take_action_at = Time.new + (60 * 5)
    @bounce.save

    @follow.bounce = @bounce
    @follow.save
  end
end
