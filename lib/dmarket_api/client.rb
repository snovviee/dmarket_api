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
      aggregated_price: { path: '/price-aggregator/v1/aggregated-prices', verb: :get },
      user: { path: '/account/v1/user', verb: :get }
    }

    def initialize(api_key:, secret_key:)
      @api_key = api_key
      @secret_key = secret_key
    end

    def connection
      @connection ||= Connection.create(api_key: api_key, secret_key: secret_key)
    end

    def balance
      endpoint = ENDPOINTS[__callee__]
      connection.send(endpoint[:verb], endpoint[:path])
    end

    def buy(body)
      endpoint = ENDPOINTS[__callee__]
      connection.send(endpoint[:verb], endpoint[:path], body)
    end

    def title_offers(body)
      endpoint = ENDPOINTS[__callee__]
      connection.send(endpoint[:verb], endpoint[:path], body)
    end
  end
end
