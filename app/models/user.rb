class User < ActiveRecord::Base
  belongs_to :twitter_user
  has_many :follows
  has_many :followed_twitter_users, { :through => :follows, :source => :twitter_user, :class_name => 'TwitterUser' }
  
  def default_search_twitter_users
    
    # Need to come back to this code
    
#    TwitterUser.
#      joins(
#        [
#          'join follows on (follows.twitter_user_id=twitter_user.id)',
#          'left join users on (users.twitter_user_id=twitter_users.id)',
#        ]
#      ). 
#      conditions (['follows.user_id', self.id])
#      
#      :conditions => [],
#      :group
#    )
  end
    
end
