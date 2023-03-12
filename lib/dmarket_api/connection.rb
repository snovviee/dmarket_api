require_relative 'signature_middleware'
require 'byebug'

module DmarketApi
  class Connection
    private_class_method :new

    Faraday::NestedParamsEncoder.sort_params = false
    Faraday::Request.register_middleware dmarket_signature: -> { SignatureMiddleware }

    HOST = 'https://api.dmarket.com'

    class << self
      def create(api_key:, secret_key:)
        Faraday.new(
          url: HOST,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-Api-Key': api_key,
            'X-Sign-Date': timestamp
          }
        ) do |f|
          f.request :url_encoded
          f.request :dmarket_signature, secret_key.gsub(api_key, '')
          f.response :json, parser_options: { symbolize_names: true }
        end
      end

      private

      def timestamp
        Time.now.to_i.to_s
      end
    end
  end
end
