require "net/http"
require "uri"
require "openssl"
require "./key"
require "json"

def order(side,price,size)
  key = "API_KEY"
  secret = "API_SECRET"
  timestamp = Time.now.to_i.to_s
  method = "POST"
  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = "/v1/me/sendchildorder"
  body = '{
    "product_code": "BTC_JPY",
    "child_order_type": "LIMIT",
    "side": "'+ side +'",
    "price": ' + price +',
    "size": ' + size +',
    "minute_to_expire": 10000,
    "time_in_force": "GTC"
  }'
  text = timestamp + method + uri.request_uri + body
  sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)
  options = Net::HTTP::Post.new(uri.request_uri, initheader = {
  "ACCESS-KEY" => key,
  "ACCESS-TIMESTAMP" => timestamp,
  "ACCESS-SIGN" => sign,
  "Content-Type" => "application/json"
  });
  options.body = body
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.request(options)
  puts response.body
end

 def get_price
   uri = URI.parse("https://api.bitflyer.jp")
  uri.path = '/v1/getboard'
  uri.query = ''
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.get uri.request_uri
  response.body
  response_hash = JSON.parse(response.body)
  response_hash["mid_price"]
end
