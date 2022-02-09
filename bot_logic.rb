require "uri"
require "json"
require "net/http"

#The module is for indexing and showing properties
module Property
  def self.index
    url = URI("https://api-bluffhope.herokuapp.com/properties")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = https.request(request)
    
    g=response.read_body
    JSON.parse(g)
  end

  def self.show(id)
    url = URI("https://api-bluffhope.herokuapp.com/properties/#{id}")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    
    request = Net::HTTP::Get.new(url)
    
    response = https.request(request)

    property = JSON.parse(response)
    
    message.body("City:   #{property["city"].to_s}\nAddress:  #{property["address"].to_s}\nContact:  #{property["contact"].to_s}\n\n")
  end
end
  
# THis module is for registering customers and subscriptions
module Customer
  def self.register(name, phone)
    url = URI("https://api-bluffhope.herokuapp.com/customers")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"

    request.body = JSON.dump({
      "name": name,
      "phone": phone
    })
  end

  def self.subscribe(body, phone)
    url = URI("https://api-bluffhope.herokuapp.com/subscriptions")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    
    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = "application/json"

    response.body = JSON.dump({
      "ecocash_number": body,
      "phone": phone
    })

    response = http.request(request)
    message.body(response.read_body)
  end
end
  
#This module is for Admin actions such as adding and updating a property listing and also changing the subscription price.
module Admin
  def self.new_property (city, address, description, contact) 
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
      "user_id": "2"
    })

    response = https.request(request)
    house = response.read_body
    house = JSON.parse(house)
    
    house.each do |product|
      message.body("
        City:     #{product["city"].to_s}\n
        Address:  #{product["address"].to_s}\n
        Contact:  #{product["contact"].to_s}\n\n
        You have successifully added a house listing!")
    end
  end

  def self.update_property
    url = URI("https://api-bluffhope.herokuapp.com/properties")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    
    request = Net::HTTP::Put.new(url)
    request["Content-Type"] = "application/json"

    request.body = JSON.dump({
      "city": city,
      "description": desc,
      "address": address,
      "contact": contact,
      "user_id": "2"
    })
    
    response = https.request(request)

    updated_property = JSON.parse(response)

    updated_property.each do |house|
      message.body("
        City:     #{house["city"].to_s}\n
        Address:  #{house["address"].to_s}\n
        Contact:  #{house["contact"].to_s}\n\n
        You have successifully added a house listing!")
    end
  end

  def self.set_amount(price)
    url = URI("https://api-bluffhope.herokuapp.com/amounts")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    
    request = Net::HTTP::Put.new(url)
    request["Content-Type"] = "application/json"

    request.body = JSON.dump({
      "price": price,
      "user_id": "1"
    })

    response = httpa.request(request)
    response = JSON.parse(response)
    
    response.each do |price|
      message.body("You have successifully set the subscription
                    price to #{price["price"]}")
    end
  end
  
end