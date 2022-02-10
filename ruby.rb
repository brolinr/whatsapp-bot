require "uri"
require "json"
require "net/http"

body = "Harare#67058 Glenview 7#4 bedroom house with lounge#07712323"
if body.include?("#")
  parameters = body.split(/#/)

  city1 = parameters[0]
  address1 = parameters[1]
  description1 = parameters[2]
  contact1 = parameters[3]
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
     puts"City:     #{deserialize["city"].to_s}\nAddress:  #{deserialize["address"].to_s}\nContact:  #{deserialize["contact"].to_s}\n\nYou have successifully added a house listing!"
    end
    new_property(city1, address1, description1, contact1)
end


