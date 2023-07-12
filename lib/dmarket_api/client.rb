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
      items: { path: '/exchange/v1/market/items', verb: :get },
      user_items: { path: '/exchange/v1/user/items', verb: :get },
      customized_fees: { path: '/exchange/v1/customized-fees', verb: :get },
      deposit_assets: { path: '/marketplace-api/v1/deposit-assets', verb: :post },
      user_offers: { path: '/marketplace-api/v1/user-offers', verb: :get },
      user_offers_closed: { path: '/marketplace-api/v1/user-offers/closed', verb: :get },
      user_offers_create: { path: '/marketplace-api/v1/user-offers/create', verb: :post },
      user_offers_edit: { path: '/marketplace-api/v1/user-offers/edit', verb: :post },
      offers_delete: { path: '/exchange/v1/offers', verb: :delete },
      user_targets: { path: '/marketplace-api/v1/user-targets', verb: :get },
      user_targets_create: { path: '/marketplace-api/v1/user-targets/create', verb: :post },
      user_targets_delete: { path: '/marketplace-api/v1/user-targets/delete', verb: :post },
      user_targets_closed: { path: '/marketplace-api/v1/user-targets/closed', verb: :get }
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

    def history(params = {})
      response = connection.get("/marketplace-api/v1/sales-history", params)
      response.body if response.success?
    end

    def last_sales(params = {})
      response = connection.get("/marketplace-api/v1/last-sales", params)
      response.body if response.success?
    end
  end
end
