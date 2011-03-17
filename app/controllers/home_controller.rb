class HomeController < ApplicationController
  
  FRIENDS_COUNT_LIMIT = 5000
  
  def index
    if @logged_in_user.nil?
      render :action => 'index_not_logged_in'
      return
    end
    
    if @logged_in_user.updated_friends_at.nil?
      if @logged_in_user.update_friends_progress.nil?
        if @logged_in_user.twitter_user.friends_count > FRIENDS_COUNT_LIMIT
          render :action => 'too_many_follows'
          return
        end
        
        @logged_in_user.update_friends_progress = 0
        @logged_in_user.save
  
        Delayed::Job.enqueue(@logged_in_user)
      end
      
      render :action => 'first_time_friend_update'
      return
    end
    
    if Time.now - @logged_in_user.updated_friends_at > (60 * 60 * 1)
      @logged_in_user.update_friends_progress = 0
      @logged_in_user.save

      Delayed::Job.enqueue(@logged_in_user)
    end

    @past_bounces = Bounce.where(['hide_past_bounces=? and executed_at is not null', false]).order('executed_at desc').limit(3)
      
    find_params = { 
        :limit => SearchController::LIMIT, 
        :include => [:twitter_user ],
        :order => 'bounces.take_action_at'
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
