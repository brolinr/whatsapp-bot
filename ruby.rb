
require_relative "bot_logic"

body = "Harare#67058 Glenview 7#4 bedroom house with lounge#07712323"
if body.include?("#")
  parameters = body.split(/#/)

  city1 = parameters[0]
  address1 = parameters[1]
  description1 = parameters[2]
  contact1 = parameters[3]
  Admin.new_property(city1, address1, description1, contact1)
end


