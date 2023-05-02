require_relative 'connection'

module DmarketApi
  class Client
    attr_reader :api_key, :secret_key

    ENDPOINTS = {
      title_offers: { path: '/exchange/v1/offers-by-title', verb: :get },
      balance: { path: '/account/v1/balance', verb: :get },
      withdraw: { path: '/exchange/v1/withdraw-assets', verb: :post },
      inventory_sync: { path: '/marketplace-api/v1/user-inventory/sync', verb: :post },
      buy: { path: '/exchange/v1/offers-buy', verb: :patch },
      aggregated_prices: { path: '/price-aggregator/v1/aggregated-prices', verb: :get },
      user: { path: '/account/v1/user', verb: :get },
      inventory: { path: '/marketplace-api/v1/user-inventory', verb: :get },
      items: { path: '/exchange/v1/market/items', verb: :get }
    }

    def initialize(api_key:, secret_key:)
      @api_key = api_key
      @secret_key = secret_key
      ENDPOINTS.each do |_method, declaration|
        block = ->(body) do
          body = body.to_json if declaration[:verb] == (:post || :path )
          connection.send(declaration[:verb], declaration[:path], body)
        end

        self.class.define_method(_method) { |body={}| block.call(body) }
      end
    end

    def connection
      @connection ||= Connection.create(api_key: api_key, secret_key: secret_key)
    end
  end
end
