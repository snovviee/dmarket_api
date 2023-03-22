require 'faraday'
require 'ed25519'

module DmarketApi
  class SignatureMiddleware < ::Faraday::Middleware
    attr_reader :secret_key

    def initialize(app, secret_key)
      super(app)

      @secret_key = secret_key
    end

    def on_request(env)
      env.request_headers['X-Request-Sign'] = signature(env)
      env.request_headers['X-Sign-Date'] = timestamp
    end

    private

    def signature(env)
      body = env.request_body ? env.request_body : ''
      unsigned_string = env.method.to_s.upcase + env.url.request_uri + body

      signed_string = signing_key.sign(unsigned_string + timestamp)
      signature = signed_string.bytes.pack("c*").unpack("H*").first
      "dmar ed25519 " + signature
    end

    def signing_key
      str_32_bytes = secret_key.scan(/../).map { |x| x.hex.chr }.join

      Ed25519::SigningKey.new(str_32_bytes)
    end

    def timestamp
      Time.now.to_i.to_s
    end
  end
end
