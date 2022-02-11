require "uri"
require "json"
require "net/http"
module Property
    def self.create
        require "uri"
        require "json"
        require "net/http"
        
        url = URI("http://localhost:3000/amounts")
        
        http = Net::HTTP.new(url.host, url.port);
        request = Net::HTTP::Post.new(url)
        request["Content-Type"] = "application/json"
        request.body = JSON.dump({
          "price": "450",
          "user_id": "1"
        })
        
        response = http.request(request)
        deserialize = response.read_body
        deserialize = JSON(deserialize)
        puts"The subscription price has been changed to #{deserialize["price"]}"

end
end
Property.create
