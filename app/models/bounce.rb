class Bounce < ActiveRecord::Base
  belongs_to :user
  belongs_to :twitter_user
end
