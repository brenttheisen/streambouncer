class HomeController < ApplicationController
  
  def index
    if @logged_in_user.nil?
      render :action => 'index_not_logged_in'
      return
    end

    @past_bounces = Bounce.where(['hide_past_bounces=? and executed_at is not null', false]).order('executed_at desc').limit(3)
    @follows = Follow.joins('left join bounces on (follows.bounce_id=bounces.id)').where(['follows.user_id=?', @logged_in_user.id]).order('if(follows.bounce_id is null, 1, 0), bounces.take_action_at').offset(params[:o]).limit(20)
  end
end
