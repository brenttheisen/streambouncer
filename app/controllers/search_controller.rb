class SearchController < ApplicationController
  
  LIMIT = 20
  
  def index
    @offset = (params[:o].nil? || params[:o].length == 0) ? 0 : params[:o].to_i
    
    find_params = { :offset => @offset, :limit => LIMIT, :include => [:twitter_user ] }
    if params[:q].nil? || params[:q].strip.length == 0
      find_params[:order] = 'bounces.take_action_at'
      common_params = {
        :joins => 'left join bounces on (follows.active_bounce_id=bounces.id)',
        :conditions => ['follows.user_id=?', @logged_in_user.id],
      }
    else
      common_params = {
        :joins => 'join twitter_users on (follows.twitter_user_id=twitter_users.id)',
        :conditions => ['follows.user_id=? and twitter_users.username like ?', @logged_in_user.id, "%#{params[:q]}%"]
      }
    end

    @follows_count = Follow.count(common_params)
    @follows = @offset < @follows_count ? Follow.find(:all, find_params.merge(common_params)) : []
    @end_of_follows = @offset + LIMIT >= @follows_count
  end
end
