require './invite_service'

invite = InviteService.new
puts "....:::: Customers to invite ::::...."
puts invite.find_customers_in_range
