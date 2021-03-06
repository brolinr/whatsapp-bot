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

  def self.show(id, phone)
    url = URI("https://api-bluffhope.herokuapp.com/properties/#{id}")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = "application/json"

    request.body = JSON.dump({
      "phone": phone
    })
    response = https.request(request)
      house = response.read_body
      JSON.parse(house)
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
    
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({
      "ecocash_number": body,
      "phone": phone
    })
    
    response1 = https.request(request)
    response1.read_body
  end

  def self.feedback(description, phone)
    url = URI("https://api-bluffhope.herokuapp.com/feedbacks/")

    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({
      "description": description,
      "phone": phone
    })
    
    response = https.request(request)
    puts response.read_body    
  end

end

#This module is for Admin actions such as adding and updating a property listing and also changing the subscription price.
module Admin
  def self.new_property(description, contact) 
    url = URI("https://api-bluffhope.herokuapp.com/properties")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"

    request.body = JSON.dump({
      "description": description,
      "contact": contact,
      "user_id": "1"
    })

    response = https.request(request)
    deserialize = response.read_body
    JSON.parse(deserialize)
  end

  def self.update_property(id, description, contact)
    url = URI("https://api-bluffhope.herokuapp.com/properties#{id}")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    
    request = Net::HTTP::Put.new(url)
    request["Content-Type"] = "application/json"

    request.body = JSON.dump({
      "description": description,
      "contact": contact,
      "user_id": "1"
    })
    
    response = https.request(request)

    deserialize = response.read_body
    JSON(deserialize)
  end

  def self.delete_property(id)
    url = URI("https://api-bluffhope.herokuapp.com/properties/#{id}")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    
    request = Net::HTTP::Delete.new(url)
    
    response = https.request(request)
    g = response.read_body
  end
  
  def self.set_amount(price)
    url = URI("https://api-bluffhope.herokuapp.com/amounts")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"

    request.body = JSON.dump({
      "price": price
    })

    response = https.request(request)
    deserialize = response.read_body
    JSON(deserialize)
    
  end
  
end