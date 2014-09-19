require 'httparty'
require 'redis'
require 'twitter'

module Books
  class Bot
    LISTS = {
      fiction:    'combined-print-and-e-book-fiction',
      nonfiction: 'combined-print-and-e-book-nonfiction',
      advice:     'advice-how-to-and-miscellaneous'
    }

    def run
      books = fiction_books + nonfiction_books + advice_books

      books.each do |book|
        title = book['book_details'][0]['title']
        author = book['book_details'][0]['author']
        url = book['book_details'][0]['amazon_product_url']
        next unless new?(book)
        next if tweeted?(title)
        tweet(title, author, url)
      end
    end

    private

    def fiction_books
      HTTParty.get("#{NYT_ENDPOINT}#{LISTS[:fiction]}.json?api-key=#{NYT_API_KEY}")['results']
    end

    def nonfiction_books
      HTTParty.get("#{NYT_ENDPOINT}#{LISTS[:nonfiction]}.json?api-key=#{NYT_API_KEY}")['results']
    end

    def advice_books
      HTTParty.get("#{NYT_ENDPOINT}#{LISTS[:advice]}.json?api-key=#{NYT_API_KEY}")['results']
    end

    # check if the book is new in the list
    def new?(book)
      book['weeks_on_list'] == 1
    end

    # check if book title is in redis
    def tweeted?(title)
      Books.redis[title]
    end

    def tweet(title, author, url)
      msg = "#{title} – by #{author}\n\n#{url}"
      Books.redis[title] = 'true'
      if (ENV['RACK_ENV'] == 'production')
        Books.twitter.update(msg)
      else
        puts msg
      end
    end

  end
end
