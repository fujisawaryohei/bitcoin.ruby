require 'net/http'
require 'uri'
require 'json'

uri = URI.parse("https://api.bitflyer.jp")
uri.path = '/v1/getboard'
uri.query = ''
https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true
response = https.get uri.request_uri
puts response.body
response_hash = JSON.parse(response.body)
puts response_hash["mid_price"]
