$LOAD_PATH.unshift 'lib'
require 'books'

namespace :bot do
  desc 'Run the bot'
  task :run do
    bot = Books::Bot.new
    bot.run
  end
end
