class AdminController < ApplicationController
  
  ADMIN_TWITTER_USERNAMES = [ 'brenttheisen', 'danroose' ]
  
  def index
    render :layout => false, :file => "#{RAILS_ROOT}/public/404.html" if @logged_in_user.nil? || !ADMIN_TWITTER_USERNAMES.include?(@logged_in_user.twitter_user.username)
    
    @users = User.order('last_login_at desc').includes([ :twitter_user ])
  end
end
