class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :twitter_user
  belongs_to :active_bounce, :class_name => 'Bounce'
end
