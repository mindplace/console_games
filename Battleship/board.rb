class Board
  attr_reader :empty
  attr_accessor :grid
  
  def initialize(grid=self.class.default_grid)
    @grid = grid unless block_given?
    @grid = yield if block_given?
  end
  
  def [](pos)
    grid[pos[0]][pos[1]]
  end
  
  def self.default_grid
    Array.new(10) {Array.new(10)} 
  end

  def count
    grid.flatten.count(:s)
  end
  
  def empty?(pos=nil)
    if pos != nil
      grid[pos[0]][pos[1]] == nil
    elsif grid.flatten.compact.select{|x| x == :s}.length == 0
      true 
    else
      false
    end
  end
    
  def full?
    grid.flatten.compact.length == grid.flatten.length
  end
  
  def place_random_ship
    empty_locations = []
    grid.each_with_index do |row, i|
      row.each_with_index do |column, j|
        empty_locations << [i, j] if grid[i][j].nil?
      end
    end
    pos = empty_locations.sample
    @grid[pos[0]][pos[1]] = :s
  end
  
  def won?
    empty?
  end
end
