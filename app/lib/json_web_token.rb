# app/lib/json_web_token.rb
module JsonWebToken
    extend self
  
    # use Rails credentials or ENV for real apps
    SECRET = Rails.application.credentials.dig(:jwt, :secret) || ENV["JWT_SECRET"] || Rails.application.secret_key_base
  
    def encode(payload, exp: 15.minutes.from_now)
      payload = payload.dup
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET, "HS256")
    end
  
    def decode(token)
      body = JWT.decode(token, SECRET, true, { algorithm: "HS256" }).first
      HashWithIndifferentAccess.new(body)
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      raise e
    end
  end
  