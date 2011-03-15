class SearchController < ApplicationController
  
  def index
    @remove_results = params[:o].nil? || params[:o] == 0
    if params[:q].nil? || params[:q].strip.length == 0
      # Default query
      @follows = Follow.joins('left join bounces on (follows.bounce_id=bounces.id)').order('if(follows.bounce_id is null, 1, 0), bounces.take_action_at').offset(params[:o]).limit(20)
    else
      @follows = Follow.where(['twitter_users.username like ?', "%#{params[:q]}%"]).offset(params[:o]).limit(20)
    end
  end
end
