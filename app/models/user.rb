class User < ActiveRecord::Base
  belongs_to :twitter_user
  has_many :follows
  has_many :followed_twitter_users, { :through => :follows, :source => :twitter_user, :class_name => 'TwitterUser' }
  
  def twitter_client
    TwitterOAuth::Client.new(
      :consumer_key => StreamBouncer::Application.config['twitter_consumer_key'],
      :consumer_secret => StreamBouncer::Application.config['twitter_consumer_secret'],
      :token => self.twitter_access_token, 
      :secret => self.twitter_access_token_secret
    )
  end
    
end
