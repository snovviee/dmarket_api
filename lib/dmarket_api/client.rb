require_relative 'connection'

module DmarketApi
  class Client
    attr_reader :api_key, :secret_key

    def initialize(api_key:, secret_key:)
      @api_key = api_key
      @secret_key = secret_key
    end

    def connection
      @connection ||= Connection.create(api_key: api_key, secret_key: secret_key)
    end

    def fetch_balance
      connection.get('/account/v1/balance')
    end
  end
end
