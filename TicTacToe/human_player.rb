class HumanPlayer
  attr_accessor :mark
  
  def initialize(name)
    @name = name
  end
  
  def name
    @name
  end
  
  def display(board)
    board = board.grid.flatten.map{|item| item.nil? ? item = "_" : item}
    puts "\n | 0 | 1 | 2 "
    puts " ------------"
    puts "0| #{board[0]} | #{board[1]} | #{board[2]}"
    puts "1| #{board[3]} | #{board[4]} | #{board[5]}"
    puts "2| #{board[6]} | #{board[7]} | #{board[8]}\n\n"
  end
  
  def get_move
    puts "where"
    move = gets.chomp.split(",")
    [move[0].to_i, move[1].to_i]
  end
end
