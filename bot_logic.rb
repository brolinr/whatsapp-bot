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
    g=response.read_body
    response=JSON.parse(g)
    message.body("Description:   #{response["description"].to_s}\nAddress:  #{response["address"].to_s}\nContact:  #{response["contact"].to_s}\n\n")
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
    response = https.request(request)
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

    response = https.request(request)
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

    message.body("Description:   #{response["description"].to_s}\nAddress:  #{response["address"].to_s}\nContact:  #{response["contact"].to_s}\n\n")

    response = https.request(request)
    deserialize = response.read_body
    deserialize = JSON.parse(deserialize)
    message.body("City:     #{deserialize["city"].to_s}\nAddress:  #{deserialize["address"].to_s}\nContact:  #{deserialize["contact"].to_s}\n\nYou have successifully added a house listing!")
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