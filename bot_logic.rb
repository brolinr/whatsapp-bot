require "uri"
require "json"
require "net/http"

module Property
    def self.index
      url = URI("https://api-bluffhope.herokuapp.com/properties/")

      http = Net::HTTP.new(url.host, url.port);
      request = Net::HTTP::Get.new(url)
      
      response = http.request(request)
       g=response.read_body
       JSON.parse(g)
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
        "city": name,
        "address": address,
        "description": description,
        "contact": contact,
        "user_id": "1"
      })

      response = http.request(request)
      house = response.read_body
      house = JSON.parse(house)
      
      house.each do |product|
        message.body("
          City:\t\t#{house["city"].to_s}\n\n
          Address:\t\t#{house["address"].to_s}\n\n
          Contact:\t\t#{house["contact"].to_s}\n\n
          You have successifully added a house listing!")
      end
    end

    def self.update_property
      JSON.parse(response.to_s)["message"]
    end

    def self.set_amount(price)
      url = URI("https://api-bluffhope.herokuapp.com/amounts")

      http = Net::HTTP.new(url.host, url.port);
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request.body = JSON.dump({
        "price": price,
        "user_id": "1"
      })

      response = http.request(request)
      response = JSON.parse(response)
      
      response.each do |price|
        message.body("You have successifully set the subscription
                      price to #{price["price"]}")
        end
    end
    
  end