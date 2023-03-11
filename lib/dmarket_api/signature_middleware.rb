require 'openssl'
require 'faraday'

module DmarketApi
  class SignatureMiddleware < ::Faraday::Middleware
    attr_reader :secret_key

    def initialize(app, secret_key)
      super(app)

      @secret_key = secret_key
    end

    def on_request(env)
      if env.url.query
        signature = signature(env.url.query)
        env.url.query += "&signature=#{signature}"
      elsif env.request_body
        signature = signature(env.request_body)
        env.request_body += "&signature=#{signature}"
      end
    end

    private

    def signature(data)
      OpenSSL::HMAC.hexdigest("SHA256", secret_key, data)
    end
  end
end
