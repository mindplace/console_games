class Board
  attr_reader :grid
  
  def initialize(grid=[[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]])
    @grid = grid
  end
  
  def [](row, column)
    @grid[row][column]  
  end
  
  def []=(row, column, symbol)
    @grid[row][column] = symbol
  end
  
  def place_mark(position, symbol)
    self[*position] = symbol
  end
  
  def empty?(position)
    self[*position].nil?
  end
  
  def place_marks(positions, symbol)
    postions.each do |position|
      place_mark(position, symbol)
    end
  end
  
  def over?
    if @grid.flatten.count(nil) == 0 
      true
    elsif winner == :X || winner == :O
      true
    else
      false
    end
  end
  
  def sets
    grid = @grid.dup
    row_set = []
    grid.each do |row| 
      x_count = row.count(:X)
      o_count = row.count(:O)
      row_set << row if x_count == 3 || o_count == 3
    end
    return row_set.flatten.pop if row_set.flatten.length == 3
    
    first_column = []
    second_column = []
    third_column = []

    grid.each do |row|
      first_column << row[0]
      second_column << row[1]
      third_column << row[2]
    end
    diagonal_set_forward = [grid[0][2], grid[1][1], grid[2][0]]
    diagonal_set_backslash = [grid[0][0], grid[1][1], grid[2][2]]
    
    if first_column.compact.uniq.length == 1 && 
       first_column.count(first_column.compact.last) == 3
      first_column.pop
    elsif second_column.compact.uniq.length == 1 &&
          second_column.count(second_column.compact.last) == 3
      second_column.flatten.pop
    elsif third_column.compact.uniq.length == 1 &&
          third_column.count(third_column.compact.last) == 3
      third_column.flatten.pop
    elsif diagonal_set_backslash.compact.uniq.length == 1 &&
          diagonal_set_backslash.count(diagonal_set_backslash.compact.last) == 3
      diagonal_set_backslash.flatten.pop
    elsif diagonal_set_forward.compact.uniq.length == 1 &&
          diagonal_set_forward.count(diagonal_set_forward.compact.last) == 3
      diagonal_set_forward.flatten.pop
    end
  end
  
  def winner
    sets
  end
end

