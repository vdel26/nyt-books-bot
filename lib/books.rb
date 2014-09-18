module Books
  NYT_API_KEY = ENV['NYT_API_KEY']

  def self.redis
    @@redis ||= begin
      uri = URI.parse(ENV['REDISTOGO_URL'] || 'redis://localhost:6379')
      Redis.new(host: uri.host, port: uri.port, password: uri.password)
    end
  end
end

require 'books/server'
require 'books/bot'
