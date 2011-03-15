class HomeController < ApplicationController
  
  def index
    if @logged_in_user.nil?
      render :action => 'index_not_logged_in'
      return
    end

    @past_bounces = Bounce.where(['hide_past_bounces=? and executed_at is not null', false]).order('executed_at desc').limit(3)
      
    find_params = { 
        :limit => SearchController::LIMIT, 
        :include => [:twitter_user ],
        :order => 'if(follows.bounce_id is null, 1, 0), bounces.take_action_at'
    }
    common_params = {
      :joins => 'left join bounces on (follows.bounce_id=bounces.id)',
      :conditions => ['follows.user_id=?', @logged_in_user.id],
    }

    @follows_count = Follow.count(common_params)
    @follows = @follows_count > 0 ? Follow.find(:all, find_params.merge(common_params)) : []
    @end_of_follows = SearchController::LIMIT >= @follows_count
  end
end
