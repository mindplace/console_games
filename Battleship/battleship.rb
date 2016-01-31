require_relative 'board'
require_relative 'player'

class BattleshipGame
  attr_reader :board, :player
  
  def initialize(player=Player.new, board=Board.new)
    @board = board
    @player = player
  end
  
  def rules
    puts "
                        Battleship!
                
        There is only one board. The computer will fill 
        it with ships at random, and it will be your job
        to find and destroy these ships by guessing their 
        coordinates.
        
        The game will have these ships on the board:
        1 Aircraft carrier (5x long)
        1 Battleship (4x long)
        2 Submarines (3x long)
        2 Destroyers (2x long)
        
        The game will display those of your hits that hit 
        ships as x, and note where your hits didn't hit 
        anything as -, and keep a counter of how many ship 
        sections are still on the board. E.g., hitting a 
        Submarine in 1 spot will leave 2 spots for the 
        counter to show. \n\n"
  end
  
  def offer_rules
    puts "Would you like to see the rules?"
    choice = gets.chomp
    rules if choice.include?("y")
  end
  
  def attack(pos)
    if @board.grid[pos[0]][pos[1]] == :s
      @board.grid[pos[0]][pos[1]] = :x 
    elsif @board.grid[pos[0]][pos[1]].nil?
      @board.grid[pos[0]][pos[1]] = :-
    end
  end
  
  def count
    @board.count
  end
  
  def game_over?
    board.won?
  end
  
  def play_turn
    location = player.get_play
    attack(location)
  end
  
  def endgame_message
    puts "You've destroyed all the enemy ships!!"
    puts "Thanks for playing Battleship!"
  end 
  
  def play
    offer_rules
    puts "Press enter to play:"
    gets
    while game_over? == false
      puts "There are #{board.count} ship spots remaining."
      fired_board = board.grid
      player.display(fired_board)
      player.prompt
      play_turn
    end
    
    if game_over?
      player.display(board.grid)
      endgame_message
    end 
  end
end


if __FILE__ == $PROGRAM_NAME
  var = [1,2,3,4,5].sample
  require File.dirname(__FILE__) + "/preset_boards/board#{var}"
  
  puts "Let's play Battleship!"
  puts "Computer will populate a board with ships, and you'll be firing."
  player = HumanPlayer.new
  board = Board.new(preset_board)
  game = BattleshipGame.new(player, board)
  game.play
end