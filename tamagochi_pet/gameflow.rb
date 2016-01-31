# initiate the pet
# pet has:
# health, happiness, age, hunger, boredom
#
# one instance virtual pet -- exists until the pet falls asleep
# 
# time based: every 1 minute checkin, one unit of time is 1 minute
# every minute: 
#   hunger rises by x
#   boredom rises by x
#   happiness drops by x (randomly amuse itself)
#   health drops by x
# 
# Interactions -- user can:
#   feed it (hunger drops by x)
#   play games with it (happiness goes up by x, boredom drops by x)
#   groom it (happines goes up by x, health goes up by x)
#       give it a bath (health rises by 2x, happiness goes down by 1x)
#       brush it (health rises by 1x, happines rises by 2x)
#   treat it for illness (health goes up by x)
#   put it to bed (end the game)
#   
# reactions to interaction
#
# games:
#   fetch
#   rock paper scissors 
#   towers of hanoi
#   number guessing game
