# Towers of Hanoi
# http://en.wikipedia.org/wiki/Towers_of_hanoi

class TowersOfHanoi
  attr_reader :towers, :moves_count
  
  def initialize
    @towers = [[3, 2, 1], [], []]
    @moves_count = 0
  end
  
  def rules
    puts "
      The Towers of Hanoi is a mathematical game or puzzle. It consists of 
      three rods and three disks of different sizes which can slide onto any 
      rod. The puzzle starts with the disks in a stack of descending sizes 
      on the leftmost rod.

      Move the entire stack to the rightmost rod under these rules:

        1. Only one disk can be moved at a time.
        2. Each move consists of taking the upper disk from one of the stacks 
           and placing it on top of another stack i.e. a disk can only be moved 
           if it is the uppermost disk on a stack.
        3. No disk may be placed on top of a smaller disk."
  end
  
  def offer_rules
    puts "Want to see the rules? (yes/no)"
    answer = gets.chomp
    rules if answer.include?("y")
  end
  
  def get_sets_for_rendering
    sets = towers.map do |column| 
      if column.empty? 
        column = [" ", " ", " "]
      elsif column.length < 3 && column.length > 1
        column << " "
      elsif column.length < 2 
        column << " "
        column << " "
      else
        column
      end
    end
    @towers = @towers.map{|column| column.reject{|x| x == " "} }
    sets
  end
  
  def render
    sets = get_sets_for_rendering
    puts "1st|2nd|3rd"
    puts " #{sets[0][2]} | #{sets[1][2]} | #{sets[2][2]}"
    puts " #{sets[0][1]} | #{sets[1][1]} | #{sets[2][1]}"
    puts " #{sets[0][0]} | #{sets[1][0]} | #{sets[2][0]}"
  end
  
  def locate(disk)
    if towers[0].include?(disk)
      from_tower = @towers[0]
    elsif towers[1].include?(disk)
      from_tower = @towers[1]
    else
      from_tower = @towers[2]
    end
    from_tower
  end
  
  def get_disk
    puts "Which disk would you like to move?"
    disk = gets.chomp.to_i
    
    if disk == 0 || disk > 3
      while disk == 0
        puts "Didn't catch that?"
        disk = gets.chomp.to_i
      end
      while disk > 3
        puts "There's no such disk, choose another."
        disk = gets.chomp.to_i
      end
    end
    disk
  end
  
  def get_to_tower 
    to_tower = nil
    while to_tower == nil
      puts "To which tower?"
      to_tower = gets.chomp.to_i
      to_tower = towers[to_tower - 1]
      break unless to_tower.nil?
      puts "There's no such tower, choose another." 
    end
    to_tower
  end
  
  def move(disk=nil, from_tower, to_tower)
    if disk == nil && to_tower.class == Fixnum
      disk = @towers[from_tower].pop
      @towers[to_tower] << disk
    else
      to_tower << disk
      from_tower.delete(disk)
    end
  end
  
  def valid_move?(disk=nil, from_tower, to_tower)
    if disk.nil? && from_tower.class == Fixnum
      disk = towers[from_tower].pop
      return false if disk.nil?
      next_disk = towers[to_tower].last
    else
      next_disk = to_tower.last
    end
    
    if next_disk.nil? || next_disk > disk
      true 
    elsif disk > next_disk
      false 
    end
  end
  
  def turn_invalid_move_valid(disk)
    user_choice = next_disk_is_smaller_error(disk)
    user_choice == 1 ? 1 : get_to_tower
  end
  
  def next_disk_is_smaller_error(selection)
    puts "Can't move the disk there, the next disk at that tower is smaller 
          than the disk you selected. You can choose another disk or choose 
          another tower for disk ##{selection}.\n"
    puts "Enter 1 to choose another disk, or 2 to choose another tower:"
    choice = gets.chomp.to_i
    while choice != 1 && choice != 2
      puts "Didn't catch that?"
      choice = gets.chomp.to_i
    end
    choice
  end
  
  def playing_loop
      puts "Here are the towers and their disks:\n\n"
      render 
      puts "\n"
      
      disk = get_disk
      from_tower = locate(disk)
      
      while from_tower.last != disk
        puts "Can't take a disk if it's not at the top!"
        puts "Choose another disk to move."
        disk = gets.chomp.to_i
        from_tower = locate(disk)
      end
      
      to_tower = get_to_tower
      
      while valid_move?(disk, from_tower, to_tower) == false
          user_choice = turn_invalid_move_valid(disk)
          user_choice == 1 ? break : to_tower = user_choice
      end
      
      if valid_move?(disk, from_tower, to_tower)
        move(disk, from_tower, to_tower)
        @moves_count += 1
      end
  end
  
  def won?
    towers == [[], [], [3, 2, 1]] || 
    towers == [[], [3,2,1], []]
  end
  
  def winning_message
    puts "\nYou won!!\n"
    render
    puts "\nYou finished the game in #{moves_count} moves!"
    puts "Thanks for playing :)"
  end
  
  def play
    puts "Welcome to the game!"
    offer_rules
    puts "Press enter to play!"
    gets
    playing_loop while won? == false
    winning_message
  end
end

if __FILE__ == $PROGRAM_NAME
  game = TowersOfHanoi.new
  game.play
end