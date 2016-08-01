class Keyword < ActiveRecord::Base
  def grab_tweets
    count = 5
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
      "#{tweet.user.screen_name}: #{tweet.text}"
    end
  end
end
