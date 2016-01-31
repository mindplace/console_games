#!/usr/bin/ruby

load 'GreedGame.rb'
load 'GamePlay.rb'
load 'Players.rb'
load 'DiceSet.rb'

new_game = GreedGame.new
new_game.gameplay


# changes I want to make:
#
# - make it more chance a player will choose
#   to roll again if there's more dice available
#
# - make language of the game more sensiive
#   to user and gender
#
# - making the program more into an app, maybe
#   through Heroku? Just something I can link
#   to in my GitHub so people can try it out. 