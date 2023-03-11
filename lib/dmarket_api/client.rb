require_relative 'connection'

module DmarketApi
  class Client
    include Connection::Methods

    def offers_by_title(title)
      connection.get('/exchange/v1/offers-by-title', { title: title }).body
    end
  end
end
