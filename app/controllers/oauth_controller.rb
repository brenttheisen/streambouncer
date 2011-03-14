class OauthController < ApplicationController
  
  CONSUMER_KEY = 'HtjH1S6zcrLQcxUv8iKJ9g'
  CONSUMER_SECRET = 'RIYCjfA3ChoIA29JTX9nZ2IVUUM9rqiCnndnl1ipU'
  
  CALLBACK_PROD = 'http://streambouncer.heroku.com/oauth/authorized'
  CALLBACK_TEST = 'http://localhost:3000/oauth/authorized'
  
  def twitter
    client = TwitterOAuth::Client.new(
        :consumer_key => CONSUMER_KEY,
        :consumer_secret => CONSUMER_SECRET
    )
    request_token = client.request_token(:oauth_callback => RAILS_ENV == 'production' ? CALLBACK_PROD : CALLBACK_TEST)
    #:oauth_callback required for web apps, since oauth gem by default force PIN-based flow 
    #( see http://groups.google.com/group/twitter-development-talk/browse_thread/thread/472500cfe9e7cdb9/848f834227d3e64d )
    
    session[:twitter_request_token] = request_token
    
    redirect_to request_token.authorize_url
  end
  
  def authorized
    render :layout => false
  end
  
  def close_window
    request_token = session[:twitter_request_token]
    client = TwitterOAuth::Client.new(
        :consumer_key => CONSUMER_KEY,
        :consumer_secret => CONSUMER_SECRET
    )
    access_token = client.authorize(
      request_token.token,
      request_token.secret,
      :oauth_verifier => params[:oauth_verifier]
    )
    if client.authorized?
      twitter_info = client.info
      @logged_in_user = User.
                          joins(['join twitter_users on (twitter_users.id=users.twitter_user_id)']).
                          where('twitter_users.twitter_id=?', twitter_info['id']).
                          readonly(false).
                          first
      @logged_in_user = User.new if @logged_in_user.nil?
      @logged_in_user.twitter_access_token = access_token.token
      @logged_in_user.twitter_access_token_secret = access_token.secret
      
      @logged_in_user.twitter_user = TwitterUser.new if @logged_in_user.twitter_user.nil? 
      @logged_in_user.twitter_user.update_from_response twitter_info
      @logged_in_user.save

      twitter_user_friend_ids = []
      friends = client.all_friends
      friends.each { |user| 
        twitter_user = TwitterUser.where(:twitter_id => user['id']).first
        twitter_user = TwitterUser.new if twitter_user.nil?
        twitter_user.update_from_response user
        twitter_user.save
        
        if Follow.where(:user_id => @logged_in_user.id, :twitter_user_id => twitter_user.id).count == 0
          Follow.new(:user_id => @logged_in_user.id, :twitter_user_id => twitter_user.id).save
        end
        
        twitter_user_friend_ids << twitter_user.id
      }
      
      Follow.update_all('active=true', [ 'twitter_user_id not in(?)', twitter_user_friend_ids ])
    else
      # Tell them auth failed
    end
  end
end
