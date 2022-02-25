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
    from = params["From"]
    number = from.split(/whatsapp:/)
    phone = number[1]
    name = params["ProfileName"].capitalize

    #build a response
    response = Twilio::TwiML::MessagingResponse.new

    response.message do |message|
      #IF customer greets
      if body.include?("hie") || body.include?("hi") || body.include?("ndeip") || 
         body.include?("hello") || body.include?("hey")
        message.body("Welcome #{name} to our bot by sending *agree* you agree to our terms and conditions outline below: \n\n1) You cannot view landlord's contact details without subscribing \n2) Subscription lasts for 30 days.\n3) You only use landlord's number to enquire on the listed property only\n4) Agents are restricted from using landlords' numbers for their businesses")
      end

      #Create cutsomer account if they agree to the terms and conditions
      if body.include?("agree")
        Customer.register(name, phone)
        message.body("Congratulations *#{name.capitalize}* Your account has been successifully created: \n\n1. Type 'Available houses' to view all the houses available.\n2. Type 'Subscribe' to pay a monthly suscription fee.")
      end

      #Send a list of available houses
      if body.include?("available houses")
        Property.index.each do |property|
          message.body("*_#{property["id"]}._*) *Description:*    #{property["description"].to_s}.\n\n #{name.capitalize}, Enter the number assigned to the house that interests you, for example: \n\n Type 1 to view the house assigned to 1")
        end
      end
      
      #If the cutomer requests to subscribe
      if body.include?("subscribe")
        message.body("Please enter the ecocash number which you will use to pay for the subscription:\n\n```e.g 0787777777```")
      end
      
    #If the customer send the ecocash number for paying a subscription
      if body.length == 10 && body.include?("078") || body.include?("077")
        response = Customer.subscribe(body, phone)
        message.body("*#{name}* Customer.subscribe(body, phone).\n\n Please: \n\n1.) Type 'Available houses' to view the list of all the houses available.")
      end
      #If the customer requests a to view an individual property
      if body.length == 1 && body.to_i != 0
        id = body
        house = Property.show(id, phone)
        message.body("*Description:*   #{house["description"]}\n*Contact:*  #{house["contact"]}\n\n")
      end

      #If the body includes and entry seperated by hashes then add a listing
      if body.include?("#")
        parameters = body.split(/#/)
      
        description1 = parameters[0]
        contact1 = parameters[1]
        deserialize = Admin.new_property(description1, contact1)
        message.body("*Description:*  #{deserialize["description"].to_s}\n*Contact:*  #{deserialize["contact"].to_s}\n\nYou have successifully added a house listing!")
      end

      if body.include?("delete")
        id = body.split(/delete/)
        id = id[1]
        Admin.delete_property(id)
        message.body("House number #{id} has been deleted.")
      end

     if body.include?("$")
        parameters = body.split(/##/)

        id = parameters[0]
        description = parameters[1]
        contact = parameters[2]
        deserialize = Admin.update_product(id, description, contact)
        message.body("*Description:*  #{deserialize["description"].to_s}\n*Contact:*  #{deserialize["contact"].to_s}\n\nYou have successifully updated a house listing!")
      end
      
      if body.include?("change the subscription amount to ")
        amount = body.split(/change the subscription amount to /)
        amount = amount[1]
        deserialize = Admin.set_amount(amount)
        message.body("The subscription price has been changed to #{deserialize["price"]}")
      end
    end
    
    content_type "text/xml"
    response.to_xml
  end
end

