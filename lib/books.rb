module Books
  NYT_API_KEY = ENV['NYT_API_KEY']
  NYT_ENDPOINT = 'http://api.nytimes.com/svc/books/v3/lists/'

  TWITTER_CONSUMER_KEY = ENV['TWITTER_CONSUMER_KEY']
  TWITTER_CONSUMER_SECRET = ENV['TWITTER_CONSUMER_SECRET']
  TWITTER_ACCESS_TOKEN = ENV['TWITTER_ACCESS_TOKEN']
  TWITTER_ACCESS_TOKEN_SECRET = ENV['TWITTER_ACCESS_TOKEN_SECRET']

  def self.redis
    @@redis ||= begin
      uri = URI.parse(ENV['REDISTOGO_URL'] || 'redis://localhost:6379')
      Redis.new(host: uri.host, port: uri.port, password: uri.password)
    end
  end

  def self.twitter
    @@client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = TWITTER_CONSUMER_KEY
      config.consumer_secret = TWITTER_CONSUMER_SECRET
      config.access_token = TWITTER_ACCESS_TOKEN
      config.access_token_secret = TWITTER_ACCESS_TOKEN_SECRET
    end
  end
end

require 'books/server'
require 'books/bot'
