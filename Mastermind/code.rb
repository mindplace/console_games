class Code
  attr_reader :pegs
  
  def initialize(pegs)
    @pegs = pegs
  end
  
  PEGS = {"R"=>:Red, "G"=>:Green, "B"=>:Blue, "Y"=>:Yellow, "O"=>:Orange, "P"=>:Purple}
  
  def self.random
    Code.new(Array.new(4){PEGS.keys.sample})
  end 
  
  def self.parse(input)
    input = input.upcase.split("")
    if input.select{|item| PEGS.keys.include?(item) == false}.length > 0
        raise "Invalid Color error" 
    end
    Code.new(input)
  end 
  
  def [](color)
    @pegs[color]
  end
  
  def exact_matches(input)
    exact_count = 0
    pegs_array = pegs.dup
    pegs_array.each_index do |i|
      exact_count += 1 if pegs[i] == input[i]
    end 
    exact_count
  end
  
  def near_matches(input) 
    input = input.pegs 
    pegs_array = pegs.dup
    near_count = 0
    pegs.each_index do |i|
      if pegs[i] == input[i]
        pegs_array[i] = nil 
        input[i] = 0
      end
    end
    input.each_index do |i|
      if pegs_array.include?(input[i])
        near_count += 1 
        item = pegs_array.index(input[i])
        pegs_array[item] = nil
      end 
    end 
    near_count
  end 
  
  def ==(other_code)
    return false if other_code.is_a?(String)
    pegs == other_code.pegs
  end
end