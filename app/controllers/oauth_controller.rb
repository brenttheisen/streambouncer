class OauthController < ApplicationController
  
  CALLBACK_PATH = '/oauth/authorized'
  
  def twitter
    client = TwitterOAuth::Client.new(
    	:consumer_key => StreamBouncer::Application.config['twitter_consumer_key'],
    	:consumer_secret => StreamBouncer::Application.config['twitter_consumer_secret']
    )
    request_token = client.request_token(:oauth_callback => "http://#{self.host_port_name}#{CALLBACK_PATH}")
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
    	:consumer_key => StreamBouncer::Application.config['twitter_consumer_key'],
	    :consumer_secret => StreamBouncer::Application.config['twitter_consumer_secret']
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
      
      @logged_in_user.twitter_user = TwitterUser.where(:twitter_id => twitter_info['id']) || TwitterUser.new
      @logged_in_user.twitter_user.update_from_response twitter_info
      @logged_in_user.save

      Delayed::Job.enqueue(@logged_in_user)
    else
      # Tell them auth failed
    end
  end
end
