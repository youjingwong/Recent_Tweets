class TwitterUser < ActiveRecord::Base
  has_many :tweets

  def tweets_stale?
  	tweet = Tweet.find_by(twitter_user_id: id)
  	(Time.now - tweet.updated_at) > 10
  end
end
