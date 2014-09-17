require 'httparty'

module Books
  class Bot
    NYT_ENDPOINT = 'http://api.nytimes.com/svc/books/v2/lists/'
    LISTS = {
      fiction:    'combined-print-and-e-book-fiction',
      nonfiction: 'combined-print-and-e-book-nonfiction',
      advice:     'advice-how-to-and-miscellaneous',
      business:   'business-books'
    }

    def business_books
      HTTParty.get("#{NYT_ENDPOINT}#{LISTS[:business]}.json?api-key=#{NYT_API_KEY}")
    end

    def fiction_books
      HTTParty.get("#{NYT_ENDPOINT}#{LISTS[:fiction]}.json?api-key=#{NYT_API_KEY}")
    end

    def nonfiction_books
      HTTParty.get("#{NYT_ENDPOINT}#{LISTS[:nonfiction]}.json?api-key=#{NYT_API_KEY}")
    end

    def advice_books
      HTTParty.get("#{NYT_ENDPOINT}#{LISTS[:advice]}.json?api-key=#{NYT_API_KEY}")
    end

    # check if the book is new in the list
    def new?(book)
      book['weeks_on_list'] == 1
    end

    # check if book title is in redis
    def tweeted?(book)
    end

    def run
      b = fiction_books['results']
      b.each do |book|
        title = book['book_details'][0]['title']
        author = book['book_details'][0]['author']
        next unless new?(book)
        next if tweeted?(book)
        puts "#{title} – by #{author}"
      end
    end
  end
end
