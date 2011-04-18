class TwitterBot < ActiveRecord::Base
  
  belongs_to :user
  
  TWITTER_BOT_USERNAME = 'streambouncer'
  
  def perform
    # Delayed::Job.enqueue(self, :run_at => Time.now + 300)
    
    twitter_client = self.twitter_client
    if twitter_client.nil?
      logger.fatal "Could not run TwitterBot because you have not logged in as @streambouncer yet!"
      return
    end

    # Scan for new followers and follow them    
    follower_ids = twitter_client.followers_ids
    friend_ids = twitter_client.friends_ids
    people_to_follow = follower_ids - friend_ids
    people_to_follow.each do |id|
      logger.info "StreamBouncer bot following Twitter user with ID #{id}"
      
      twitter_client.friend id
    end
    
    # Scan for new direct messages
    messages = twitter_client.messages({ 'since_id' => self.last_direct_message_id })
    if messages.size > 0
      self.last_direct_message_id = messages[0]['id']
      self.save
      messages.each { |message| self.process_direct_message(message, twitter_client) }
    end
  end
  
  def process_direct_message(message, twitter_client)
    logger.info "Processing direct message from #{message['sender']['screen_name']}: #{message['text']}"
    user = User.joins('join twitter_users on (twitter_users.id=users.twitter_user_id)').where('twitter_users.twitter_id=?', message['sender']['id']).first
    if user.nil?
      logger.info "User #{message['sender']['screen_name']} has not OAuth'd yet"
      twitter_client.message(message['sender']['id'], "Before you can use this bot you must login using Twitter at http://streambouncer.com/.")
      return
    end
    
    text = message['text']
    bounced_screen_name = nil
    take_action_at = nil
      
    # dm @streambouncer bounce @cnnbrk until tomorrow
    if text =~ /bounce (.*) until (.*)/
      bounced_screen_name = $~[1]
      take_action_at = Chronic.parse($~[2])
    elsif text =~ /bounce (.*) for (.*)/
      bounced_screen_name = $~[1]
      duration = ChronicDuration.parse($~[2])
      take_action_at = Time.now + duration unless duration.nil?
    end
    
    if bounced_screen_name.nil? || take_action_at.nil?
      logger.info "Did not understand message."
      twitter_client.message(message['sender']['id'], "Sorry but I didn't understand you message. For a list of commands go to http://streambouncer.com/bot")
    else
      follow = Follow.joins('join twitter_users on (twitter_users.id=follows.twitter_user_id)').where('twitter_users.username=?', bounced_screen_name).first
      if follow.nil? && user.update_friends_progress.nil? && Time.now - user.updated_friends_at > (60 * 60 * 1)
        user.update_friends_progress = 0
        user.save
        user.perform
      end
      follow = Follow.joins('join twitter_users on (twitter_users.id=follows.twitter_user_id)').where('twitter_users.username=?', bounced_screen_name).first

      if follow.nil?
        twitter_client.message(message['sender']['id'], "You do not follow #{bounced_screen_name}.")
      elsif follow.active_bounce
        twitter_client.message(message['sender']['id'], "You already have an active bounce for #{bounced_screen_name} that will refollow at #{follow.active_bounce.take_action_at}.")
      else
        logger.info "Unfollowing #{bounced_screen_name} for #{user.twitter_user.username} and setting bounce for #{take_action_at}."
        bounce = Bounce.create(:follow_id => follow.id, :take_action_at => take_action_at)
        follow.active_bounce = bounce
        follow.save
        user.twitter_client.unfriend(follow.twitter_user.twitter_id)
        Delayed::Job.enqueue(bounce, :run_at => bounce.take_action_at)
        twitter_client.message(message['sender']['id'], "OK, just unfollowed #{bounced_screen_name} and will refollow at #{follow.active_bounce.take_action_at}.")
      end
    end
  end
  
  def twitter_client
    twitter_bot_user = self.user
    if twitter_bot_user.nil?
      twitter_bot_user = User.joins('join twitter_users on (twitter_users.id=users.twitter_user_id)').where('twitter_users.username=?', TWITTER_BOT_USERNAME).first
      self.user = twitter_bot_user
      self.save
    end
    TwitterOAuth::Client.new(
      :consumer_key => StreamBouncer::Application.config['twitter_consumer_key'],
      :consumer_secret => StreamBouncer::Application.config['twitter_consumer_secret'],
      :token => twitter_bot_user.twitter_access_token, 
      :secret => twitter_bot_user.twitter_access_token_secret
    )
  end
end
