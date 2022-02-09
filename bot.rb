require 'sinatra/base'
require_relative 'bot_logic'

class WhatsAppBot < Sinatra::Base
  use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/bot'

  get '/' do
    "Hello World!"
  end

  post '/bot' do
    body = params["Body"].downcase
    response = Twilio::TwiML::MessagingResponse.new
    #name = User.username #store the sender's username
    #phone = User.phone #store the sender's phone

    response.message do |message|
      greeting = ["hie", "hi", "ndeip", "hey", "hello"]
      greeting.each do |g|
        if body.include?(g)
          message.body("Welcome Customer to our bot by pressing 1 or sending 
                        'agree' you agree to our terms and conditions outline below :")
        end
      end

      if body.include?("agree") || body.include?("1")
        Customer.register(name, phone)
        message.body("Congratulations Customer 
                      Your account has been successifully created: \n
                      1. Type 'Available houses' to view all the houses available.\n
                      2. Type 'Subscribe' to pay a monthly suscription fee of $10")
      end

      if body.include?("available houses")
        message.body(Property.index)
        sleep 2
        message.body("Customer, Enter the '@' symbol along with the 
                    number assigned to the house that interests you, for
                    example: \n Type @1 to view the house assigned to 1`")
      end
      
      if body.include?("subscribe")
        message.body("Please type in the ecocash number which you will use to pay for the subscription,
                      For example 0787777777")
      end
      
      if body.include?("078") || body.include?("077")
        Customer.subscribe(phone, body)
        message.body("Thank you Customer for paying you monthly subscription
                      to use our service. Please: \n
                      1. Type 'search' to search any available property.\n
                      2. Type 'Available houses' to view the list of all the houses available.")
      end

      if body.include?("@")
        message.body(Property.show(phone, id))
      end

      black_list =["hie", "hi", "ndeip", "hey", "hello", "search",
                    "Available houses", "subscribe", "agree", "1"]
      black_list.each do |b|
        if !(body.include?(b))
          message.body("I only know about dogs or cats, sorry!")
        end
      end

    end
    
    content_type "text/xml"
    response.to_xml
  end
end