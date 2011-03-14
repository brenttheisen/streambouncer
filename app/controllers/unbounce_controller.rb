class UnbounceController < ApplicationController
  def index
    @follow = Follow.where([ 'id=? and user_id=?', params[:id], @logged_in_user.id]).first
    
    @bounce = @follow.bounce
    @bounce.canceled_at Time.now
    @bounce.active = false
    @bounce.save
    
    @follow.bounce = nil
    @follow.save
  end
end
