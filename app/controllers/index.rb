configure do
  enable :sessions
end


get '/' do
  # Look in app/views/index.erb
  erb :index
end

post '/' do
	if TwitterUser.find_by(username: params[:username]).nil?
		@user = TwitterUser.create(username: params[:username])
		@tweets = Tweet.fetch_tweets!(params[:username])
		@tweets.each do |tweet|
			Tweet.create(twitter_user_id: @user.id, body: tweet.text )
		end
	end
	redirect "/#{params[:username]}"	
end

get '/:username' do
	@user = TwitterUser.find_by(username: params[:username])
	@username = @user.username
	@tweets = Tweet.where(twitter_user_id: @user.id)
	erb :'user_tweets'
end

post '/:username/stale' do
	@user = TwitterUser.find_by(username: params[:username])
	if @user.tweets_stale?
		@tweets = Tweet.fetch_tweets!(params[:username])
		@tweets.each do |tweet|
			Tweet.create(twitter_user_id: @user.id, body: tweet.text )
		end
		@tweets = Tweet.where(twitter_user_id: @user.id)
		erb :'_partials/_tweet_container'
	else
		403
	end


end