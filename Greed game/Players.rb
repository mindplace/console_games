#!/usr/bin/ruby
class Players < GreedGame
    $players = []
    $user_player = ""
    
    def initialize(name)
        @player = name
        $players << @player
    end
    
    def user_player(name)
        $user_player = name
        $players.delete($user_player)
    end
end

class UserPlayer < GreedGame
   def initialize
        @user_player
   end
    
   def enters_game
       puts "Ready to play? Give us a name."
       @@name = gets.chomp.capitalize
       user = @@name
       user = Players.new(user)
       user.user_player(@@name)
   end
   
   def introduce_others
      player_names = ["Hamish", "Claire", "Dougal", "KoolAidMan", "POTUS", "octopus", "GrumpyCat"]
      greeting = ["'hi!'", "'hello there.'", "'howdy :)'", "'grumble grumble.'", "'good day to you!'", "'HAPPY WEDNESDAY!!!'"]
      player_number = rand(2..4)
      puts "#{player_number} players decide to join the game!"
      sleep(1.25)
      player_names = player_names.sample(player_number)
      player_names.each{|player| player = Players.new(player)}
      $players.each do |player|
          puts "#{player} enters the game and says #{greeting.sample(1).join}"
          puts "Say hi to #{player}!"
          gets
      end
   end
   
   def rounds
       puts "From 1 to 10 rounds, how many rounds do you want to play, #{@@name}?"
       rounds = gets.chomp.to_i
       while rounds > 10 || rounds < 1
            puts "Not a valid number!"
            puts "From 1 to 10 rounds, how many rounds do you want to play, #{@@name}?"
            rounds = gets.chomp.to_i
       end
       $round_total = rounds
       puts "Great, everyone agrees to play #{$round_total} rounds."
       puts " "
       sleep(1)
       puts "From 1 to 3, what limit should we put on how many times a player"
       puts "can roll on their turn?"
       chances = gets.chomp.to_i
       while chances > 3 || chances < 1
            puts "Not a valid number!"
            puts "From 1 to 3, what limit should we put on how many times a player"
            puts "can roll on their turn?" 
            chances = gets.chomp.to_i
       end
       puts "Sounds good, press enter to play!"
       $chances_total = chances
       gets
   end
end