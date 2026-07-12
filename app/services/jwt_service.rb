class JwtService
  SECRET_KEY = Rails.application.secret_key_base
  REFRESH_SECRET = "#{Rails.application.secret_key_base}_refresh"

  def self.encode(payload, exp = 1.hour.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.encode_refresh(payload, exp = 7.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, REFRESH_SECRET, "HS256")
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  def self.decode_refresh(token)
    body = JWT.decode(token, REFRESH_SECRET, true, algorithm: "HS256")[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end
