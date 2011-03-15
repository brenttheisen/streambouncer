class SearchController < ApplicationController
  
  def index
    @remove_results = params[:o].nil? || params[:o] == 0
    if params[:q].nil? || params[:q].strip.length == 0
      # Default query
      @follows = Follow.joins('left join bounces on (follows.bounce_id=bounces.id)').where(['follows.user_id=?', @logged_in_user.id]).order('if(follows.bounce_id is null, 1, 0), bounces.take_action_at').offset(params[:o]).limit(20)
    else
      @follows = Follow.joins('join twitter_users on (follows.twitter_user_id=twitter_users.id)').where(['follows.user_id=? and twitter_users.username like ?', @logged_in_user.id, "%#{params[:q]}%"]).offset(params[:o]).limit(20)
    end
  end
end
