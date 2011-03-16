class User < ActiveRecord::Base
  belongs_to :twitter_user
  has_many :follows
  has_many :followed_twitter_users, { :through => :follows, :source => :twitter_user, :class_name => 'TwitterUser' }
    
  before_save :generate_cookie
  
  def perform
    client = self.twitter_client
    
    consumer = OAuth::Consumer.new(
      StreamBouncer::Application.config['twitter_consumer_key'],
      StreamBouncer::Application.config['twitter_consumer_secret'],
      { :site => 'http://api.twitter.com' }
    )

    access_token = OAuth::AccessToken.new(consumer, self.twitter_access_token, self.twitter_access_token_secret)
    next_cursor = -1
    
    twitter_user_friend_ids = []
    
    begin
      oauth_response = access_token.get("/1/statuses/friends.json?cursor=#{next_cursor}")
      json = JSON.parse(oauth_response.body)
      next_cursor = json['next_cursor']
      friends = json['users']
      
      friends.each { |user|
        twitter_user = TwitterUser.where(:twitter_id => user['id']).first
        twitter_user = TwitterUser.new if twitter_user.nil?
        twitter_user.update_from_response user
        twitter_user.save
        
        if Follow.where(:user_id => self.id, :twitter_user_id => twitter_user.id).count == 0
          Follow.new(:user_id => self.id, :twitter_user_id => twitter_user.id).save
        end
        
        twitter_user_friend_ids << twitter_user.id
      }
      
      self.update_friends_progress = ((twitter_user_friend_ids.length.to_f / self.twitter_user.friends_count.to_f) * 100.0).to_i
      self.save
    end while next_cursor != 0
        
    Follow.update_all('active=true', [ 'twitter_user_id not in(?)', twitter_user_friend_ids ])
      
    self.update_friends_progress = nil
    self.updated_friends_at = Time.now
    self.save
  end
  
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
