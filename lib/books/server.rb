require 'sinatra'

module Books
  class Server < Sinatra::Application
    get '/' do
      'nothing to see here, I am a simple bot'
    end
  end
end
