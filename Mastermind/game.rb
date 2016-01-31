require_relative 'code'

class Game
  attr_reader :new_code, :secret_code, :last_input, :turns
  
  def initialize(secret_code=Code.random)
    @secret_code = secret_code
    @last_input = ""
    @turns = 10
  end 

  def rules
    puts "
    There are six different peg colors:
    * Red
    * Green
    * Blue
    * Yellow
    * Orange
    * Purple
  
    1. The computer selects a random code of four pegs.
    2. The player gets ten turns to guess the code.
    2. The player inputs their guess like so: 
      \"RGBY\" for red-green-blue-yellow.
    3. The computer tells the player how many exact matches 
       (right color in right spot) and near matches (right 
       color, wrong spot) the player guessed.
    4. The game ends when the player guesses the code, or 
       is out of turns.\n\n"
  end
  
  def get_guess
    @last_input = gets.chomp
    @last_input = Code.parse(last_input)
  end
  
  def display_matches(input)
    near_match_count = secret_code.near_matches(input)
    exact_match_count = secret_code.exact_matches(input)
    puts "#{exact_match_count} exact matches, #{near_match_count} near matches"
  end
  
  def round 
    puts "Welcome to Mastermind!"
    puts "Would you like to see the rules? (yes or no)"
    answer = gets.chomp
    rules if answer == "yes"
    puts "Press enter to play:"
    gets
    puts "Computer has thought of a sequence."
    
    while last_input != secret_code.pegs.join && turns > 0
      puts "Last chance!" if turns == 1
      puts "Make a guess:"
      @last_input = gets.chomp.upcase
      @last_input = Code.parse(last_input)
      exact = secret_code.exact_matches(last_input)
      near = secret_code.near_matches(last_input)
      puts "Exact matches: #{exact}, Near matches: #{near}"
      @turns -= 1
    end
    
    if turns == 0 && last_input != secret_code.pegs.join
      puts "You lost. The sequence was #{secret_code.pegs.join}."
    else
      puts "You won with #{turns} turns to go!"
    end
  end
end 

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.round
end