class OauthController < ApplicationController
  
  def twitter
    client = TwitterOAuth::Client.new(
        :consumer_key => 'HtjH1S6zcrLQcxUv8iKJ9g',
        :consumer_secret => 'RIYCjfA3ChoIA29JTX9nZ2IVUUM9rqiCnndnl1ipU'
    )
    request_token = client.request_token(:oauth_callback => 'http://localhost:3000/oauth/twitter_callback')
    #:oauth_callback required for web apps, since oauth gem by default force PIN-based flow 
    #( see http://groups.google.com/group/twitter-development-talk/browse_thread/thread/472500cfe9e7cdb9/848f834227d3e64d )
    
    session[:twitter_request_token] = request_token
    
    redirect_to request_token.authorize_url
  end
  
  def twitter_callback
    request_token = session[:twitter_request_token]
    client = TwitterOAuth::Client.new(
        :consumer_key => 'HtjH1S6zcrLQcxUv8iKJ9g',
        :consumer_secret => 'RIYCjfA3ChoIA29JTX9nZ2IVUUM9rqiCnndnl1ipU'
    )
    @access_token = client.authorize(
      request_token.token,
      request_token.secret,
      :oauth_verifier => params[:oauth_verifier]
    )
    @authorized = client.authorized?
    
    @user = User.new
    @user.twitter_access_token = @access_token.token
    @user.twitter_access_token_secret = @access_token.secret
    @user.save
  end
end
