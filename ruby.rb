require_relative 'bot_logic'
body = "@1"
if body.include?("@")
    splitting = body.split(/@/)
    id = splitting[1]
    Property.show(id)
  end