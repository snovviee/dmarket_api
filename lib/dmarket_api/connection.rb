require_relative 'signature_middleware'

module DmarketApi
  class Connection
    private_class_method :new

    Faraday::NestedParamsEncoder.sort_params = false
    Faraday::Request.register_middleware dmarket_signature: -> { SignatureMiddleware }

    HOST = 'https://api.dmarket.com'

    def create
      Faraday.new(
        url: HOST,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Api-Key': api_key
        }
      ) do |f|
        f.request :url_encoded
        f.request :dmarket_signature, secret_key
        f.response :json, parser_options: { symbolize_names: true }
      end
    end

    private

    def timestamp
      DateTime.now.strftime('%Q').to_i
    end

    module Methods
      def connection
        @connection ||= Connection.create
      end
    end
  end
end
