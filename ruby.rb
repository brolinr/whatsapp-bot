require "uri"
require "json"
require "net/http"
def new
url = URI("https://api-bluffhope.herokuapp.com/subscriptions")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({
      "ecocash_number": "0771232355",
      "phone": "+263714120726"
    })
    
    response = https.request(request)
    response.read_body
    end

    puts new