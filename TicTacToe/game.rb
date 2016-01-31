require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'

class Game
  attr_accessor :current_player, :player_one, :player_two, :board
  
  def initialize(player_one, player_two)
    @player_one, @player_two = player_one, player_two
    @board = Board.new
    @current_player = player_one
    player_one.mark = :X
    player_two.mark = :O
  end
  
  def play_turn
    current_player.display(board)
    move = current_player.get_move
    mark = current_player.mark
    board.place_mark(move, mark)
    current_player.display(board)
    switch_players!
  end
  
  def switch_players!
    if self.current_player == player_one 
      @current_player = player_two
    else
      @current_player = player_one
    end
  end
  
  def winner
    if board.winner == player_one.mark
      player_one
    elsif board.winner == player_two.mark
      player_two
    else
      nil
    end
  end
  
  def play
    puts "#{player_one.name}'s mark is #{player_one.mark}, 
#{player_two.name}'s mark is #{player_two.mark}.\n\n"
    play_turn while winner == nil && board.over? == false
    player_one.display(board)
    if winner.name == nil
      puts "\nDraw!"
    else
      puts "\n#{winner.name} wins!"
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  puts "Let's play TicTacToe!"
  puts "Let's play: you vs computer.\n\n 
Input moves like so: 1, 1 \n
Press enter to play:"
  gets
  player_one = HumanPlayer.new("User")
  player_two = ComputerPlayer.new("Computer")
  game = Game.new(player_one, player_two)
  game.play
end