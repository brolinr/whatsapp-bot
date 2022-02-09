require 'sinatra/base'
require_relative 'bot_logic'

class WhatsAppBot < Sinatra::Base
  use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/bot'

  get '/' do
    "hello world"
  end

  post '/bot' do
    # FEtch the message recieved, phone number that sent it and the name of the whatsapp acount
    body = params["Body"].downcase
    phone = params["from"]
    name = params["name"]

    #build a response
    response = Twilio::TwiML::MessagingResponse.new

    response.message do |message|
      #IF customer greets
      if body.include?("hie") || body.include?("hi") || body.include?("ndeip") || 
         body.include?("hello") || body.include?("hey")
        message.body("Welcome Customer to our bot by sending 1 or 'agree' you agree to our terms and conditions outline below.")
      end

      #Create cutsomer account if they agree to the terms and conditions
      if body.include?("agree") || body.include?("1")
        Customer.register(name, phone)
        message.body("Congratulations Customer Your account has been successifully created: \n1. Type 'Available houses' to view all the houses available.\n2. Type 'Subscribe' to pay a monthly suscription fee of $10")
      end

      #Send a list of available houses
      if body.include?("available houses")
        Property.index.each do |property|
          message.body("\n#{property["id"]}.)  City:    #{property["city"].to_s}\nDescription:    #{property["description"].to_s}
            ")
        end

        message.body("\n\nCustomer, Enter the '@' symbol along with the 
                    number assigned to the house that interests you, for
                    example: \n\n Type @1 to view the house assigned to 1`")
      end
      
      #If the cutomer requests to subscribe
      if body.include?("subscribe")
        message.body("Please type in the ecocash number which you will use to pay for the subscription:    `For example 0787777777`")
      end
      
      #If the customer send the ecocash number for paying a subscription
      if body.include?("078") || body.include?("077")
        Customer.subscribe(phone, body)
        message.body("Thank you Customer for paying you monthly subscription
                      to use our service. Please: \n\n
                      1. Type 'search' to search any available property.
                      2. Type 'Available houses' to view the list of all the houses available.")
      end

      #If the customer requests a to view an individual property
      if body.include?("@")
        message.body(Property.show(phone, id))
      end

      #If the body includes and entry seperated by hashes then add a listing
      if body.include?("#")
        parameters = body.split(/#/)

        city = parameters[0]
        address = parameters[1]
        description = parameters[2]
        contact = parameters[3]

        if parameters.include?("") || parameters.include?(" ") && parameters.count == 4
          message.body("Please re-enter your input without the ##.")
          break
        end

        Admin.new_property(city, address, description, contact)
      end

=begin      
      black_list =["hie", "hi", "ndeip", "hey", "hello", "search",
                    "Available houses", "subscribe", "agree", "1"]
      black_list.each do |b|
        unless body.include?(b)
          message.body("I only know about dogs or cats, sorry!")
        end
      end
=end
    end
    
    content_type "text/xml"
    response.to_xml
  end
end

