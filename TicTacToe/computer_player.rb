class ComputerPlayer
  attr_reader :name, :board
  attr_accessor :mark
  
  def initialize(name)
    @name = name
  end

  def display(board)
    @board = board
  end
  
  def choose_winning_move(symbol)
    board = @board.grid
    return [1,1] if board[1][1].nil? && board.flatten.compact.length == 1
    move = []
    row_set = []
    board.each do |row| 
      next unless row.include?(nil)
      if row.compact.uniq.length == 1 && row.compact.last == symbol
        row_set << row
        break
      end
    end
    row_index = board.index(row_set)
    column = row_set.index(nil)
    move = [row_index, column]
    return move unless move.length < 2
    
    first_column = [board[0][0], board[1][0], board[2][0]]
    second_column = [board[0][1], board[1][1], board[2][1]]
    third_column = [board[0][2], board[1][2], board[2][2]]
    
    diagonal_set_backslash = [board[0][0], board[1][1], board[2][2]]
    diagonal_set_forward = [board[0][2], board[1][1], board[2][0]]
    
    if first_column.compact.uniq.length == 1 && 
        first_column.compact.last == symbol &&
        first_column.count(symbol) == 2
      move = [first_column.index(nil), 0]
    elsif second_column.compact.uniq.length == 1 && 
          second_column.compact.last == symbol &&
          second_column.count(symbol) == 2
      move = [second_column.index(nil), 1]
    elsif third_column.compact.uniq.length == 1 && 
          third_column.compact.last == symbol &&
          third_column.count(symbol) == 2
      move = [third_column.index(nil), 2]
    elsif diagonal_set_backslash.compact.uniq.length == 1 && 
          diagonal_set_backslash.compact.last == symbol &&
          diagonal_set_backslash.count(symbol) == 2
      location = diagonal_set_backslash.index(nil)
      move = [location,location] 
    elsif diagonal_set_forward.compact.uniq.length == 1 && 
          diagonal_set_forward.compact.last == symbol &&
          diagonal_set_forward.count(symbol) == 2
      location = diagonal_set_forward.index(nil)
      if location == 0
        move = [0,2]
      elsif location == 1
        move = [1,1]
      elsif location == 2
        move = [2,0]
      end
    end
    return move unless move.compact.length < 2
  end
  
  def choose_random_move
    board = @board.grid
    options = []
    board.each_with_index do |row, i|
      row.each_with_index do |column, j|
        if column.nil?
          options << [i,j]
        end
      end
    end
    max = options.length - 1
    options[rand(0..max)]
  end
  
  def get_move
    move = choose_winning_move(mark)
    move = choose_random_move if move.compact.empty?
    move
  end
end
