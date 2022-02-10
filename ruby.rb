require "uri"
require "json"
require "net/http"

body = "Harare#67058 Glenview 7#4 bedroom house with lounge#07712323"
if body.include?("#")
    def new_property (city, address, description, contact) 
        url = URI("https://api-bluffhope.herokuapp.com/properties")
    
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        
        request = Net::HTTP::Post.new(url)
        request["Content-Type"] = "application/json"
    
        request.body = JSON.dump({
          "city": city,
          "address": address,
          "description": description,
          "contact": contact,
          "user_id": "1"
        })
    
        response = https.request(request)
        deserialize = response.read_body
        deserialize = JSON.parse(deserialize)
       "City:     #{deserialize["city"].to_s}\nAddress:  #{deserialize["address"].to_s}\nContact:  #{deserialize["contact"].to_s}\n\nYou have successifully added a house listing!"
      end
    
    parameters = body.split(/#/)
  
    city = parameters[0]
    address = parameters[1]
    description = parameters[2]
    contact = parameters[3]
  
    new_property(city, address, description, contact)
  end

