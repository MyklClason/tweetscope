class Keyword < ActiveRecord::Base
  has_many :tweets
  
  def grab_tweets
    count = 10
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end
    
    client
    .search(self.word, count: count, result_type: "recent")
    .take(count)
    .collect do |tweet|
      Tweet.create(
        tweet_id:         tweet.id.to_s,
        tweet_created_at: tweet.created_at,
        text:             tweet.text,
        user_uid:         tweet.user.id,
        user_name:        tweet.user.name,
        user_screen_name: tweet.user.screen_name,
        user_image_url:   tweet.user.profile_image_url,
        keyword:          self
      )
    end
  end
end
