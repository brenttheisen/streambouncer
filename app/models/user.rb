class User < ActiveRecord::Base
  belongs_to :twitter_user
  has_many :follows
  has_many :followed_twitter_users, { :through => :follows, :source => :twitter_user, :class_name => 'TwitterUser' }
    
end
