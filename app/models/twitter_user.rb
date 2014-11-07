class TwitterUser < ActiveRecord::Base
  has_many :tweets

  def tweets_stale?
  	tweet = Tweet.find_by(twitter_user_id: id)
  	if tweet
  		return (Time.now - tweet.updated_at) > 10
  	else
  		false
  	end
  end

  def self.post_tweet(tweet)
  	$client.update(tweet)  	
  end
end
