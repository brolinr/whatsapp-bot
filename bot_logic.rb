require "uri"
require "json"
require "net/http"

module Property
    url = "https://api-bluffhope.herokuapp.com/properties/"

    def self.index
        response = HTTP.get(url)
        #get the list of available houses and format them and store them in a hash
        JSON.parse(response.to_s)["properties"].first
    end
  
    def self.show(phone, id)
      response = HTTP.get("https://api-bluffhope.herokuapp.com/properties/#{id}")
      JSON.parse(response.to_s)["message"]
    end
  end
  
  module Customer
    def self.register(name, phone)
      url = URI("https://api-bluffhope.herokuapp.com/customers")

      http = Net::HTTP.new(url.host, url.port);
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request.body = JSON.dump({
        "name": name,
        "phone": phone
      })
      response = http.request(request)
    end
  
    def self.subscribe(body, phone)
      url = URI("https://api-bluffhope.herokuapp.com/subscriptions")

      http = Net::HTTP.new(url.host, url.port);
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request.body = JSON.dump({
        "ecocash_number": body,
        "phone": phone
      })

      response = http.request(request)
      message.body(response.read_body)
    end
  end
  
  module Admin
    def self.new_property (name, address, description, contact) 
      url = URI("https://api-bluffhope.herokuapp.com/properties")

      http = Net::HTTP.new(url.host, url.port);
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request.body = JSON.dump({
        "name": name,
        "address": address,
        "description": description,
        "contact": contact,
        "user_id": "1"
      })
      response = http.request(request)
      product = response.read_body
    end

    def self.update_property
      JSON.parse(response.to_s)["message"]
    end
  end