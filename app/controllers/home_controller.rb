class HomeController < ApplicationController
  
  def index
    if @logged_in_user.nil?
      render :action => 'index_not_logged_in'
      return
    end

    @past_bounces = Bounce.where(['hide_past_bounces=? and executed_at is not null', false]).order('executed_at desc').limit(3)
    @follows = Follow.where(['user_id=?', @logged_in_user.id]).includes([:twitter_user, :bounce]).limit(20)
  end
end
