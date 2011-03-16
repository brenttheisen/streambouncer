class User < ActiveRecord::Base
  belongs_to :twitter_user
  has_many :follows
  has_many :followed_twitter_users, { :through => :follows, :source => :twitter_user, :class_name => 'TwitterUser' }
    
  before_save :generate_cookie
  
  def twitter_client
    TwitterOAuth::Client.new(
      :consumer_key => StreamBouncer::Application.config['twitter_consumer_key'],
      :consumer_secret => StreamBouncer::Application.config['twitter_consumer_secret'],
      :token => self.twitter_access_token, 
      :secret => self.twitter_access_token_secret
    )
  end
  
  private
  
  def generate_cookie
    if self.cookie.nil?
      self.cookie = Digest::SHA2.new.update(self.twitter_user.twitter_id.to_s + StreamBouncer::Application.config['salt']).to_s
    end
  end
    
end
