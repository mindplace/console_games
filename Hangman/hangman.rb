class Hangman
  TOTAL_GUESSES = 12
  attr_accessor :board
  attr_reader :guesser, :referee, :guesses_left
  
  def initialize(players)
    @guesser, @referee = players[:guesser], players[:referee]
    @guesses_left = TOTAL_GUESSES
  end 
  
  def setup
    length = referee.pick_secret_word
    guesser.register_secret_length(length)
    @board = [nil] * length if board.nil?
  end
  
  def take_turn
    if guesser.class == HumanPlayer
      guess = guesser.guess
      indices = referee.check_guess(guess)
      update_board(guess, indices)
      guesser.handle_response(board)
    else
      guess = guesser.guess(board)
      if guess.length > 1 && referee.class == HumanPlayer
        puts "Computer guesses '#{guess}', is this correct?(yes/no)"
        result = gets.chomp
        if result.include?("y")
          @board = guess.chars
        else 
          @guesses_left = 0
        end 
      elsif guess.length > 1 && referee.class == ComputerPlayer
        if referee.word == guess
          @board = guess
        end
      elsif guess.length == 1
        indices = referee.check_guess(guess) 
        update_board(guess, indices)
        guesser.handle_response(guess, indices)
      end
    end
  end
  
  def update_board(guess, indices)
    indices.each do |i|
      @board[i] = guess
    end
  end
  
  def won?
    return false if board.include?(nil)
    true
  end
    
  def results
    if won? == false && guesses_left == 0
      if referee.class == HumanPlayer
        puts "Computer lost!"
      else
        puts "Oh no, you lost! The word was #{referee.word}."
      end
    elsif won?
      if guesser.class == ComputerPlayer
        puts "Computer won! The word was #{board.join}."
      else
        puts "You win! The word was #{board.join}."
      end
    end
  end
  
  def play
    setup
    guesser.handle_response(board)
    while guesses_left > 0 && won? == false
      puts "\n#{guesses_left} guesses left."
      take_turn
      @guesses_left -= 1
    end
    results
  end
end

class HumanPlayer
  def pick_secret_word
    puts "Think of a word..."
    puts "How many letters long is it?"
    gets.chomp.to_i
  end
  
  def register_secret_length(length)
    puts "The secret word is #{length} letters long."
  end
  
  def check_guess(guess) 
    puts "Computer guessed #{guess}."
    puts "If the word includes #{guess}, say where
(e.g., for 'wow', 'w' is at spot 1,3 and 'o' is at 2):"
    answer = gets.chomp
    if answer == nil
      spots = []
    else
      spots = answer.split(",").map{|x| x.to_i - 1}
    end
    spots
  end
  
  def guess
    puts "Guess a letter:"
    gets.chomp
  end
  
  def handle_response(new_board)
    board = new_board.map{|item| item.nil? ? item = " _ " : item }
    puts "#{board.join}"
  end
end

class ComputerPlayer
  def self.with_dictionary_file(filename)
    ComputerPlayer.new(File.readlines(filename).map(&:chomp))
  end
  
  attr_reader :word, :word_length
  
  def initialize(dictionary)
    @dictionary = dictionary
  end
  
  def register_secret_length(length)
    @word_length = length
  end
  
  def pick_secret_word
    @word = @dictionary.sample
    word.length
  end
  
  def check_guess(guess) 
    spots = []
    word.chars.each_index do |i|
      spots << i if guess.include?(word[i])
    end
    spots
  end
  
  def candidate_words
    dictionary = @dictionary.dup
    dictionary.each do |word|
      @dictionary.delete(word) if word.length != word_length
    end
    @dictionary
  end
  
  def guess(board)
    @dictionary = candidate_words
    
    if @dictionary.length == 1
      return @dictionary.join
    end
    if board.compact.length == 0
      @dictionary.join.chars.group_by(&:itself).values.sort_by(&:length).last[0]
    else
      letters = board.compact
      selection = @dictionary.join.chars.reject{|letter| letters.include?(letter)}
      selection.group_by(&:itself).values.sort_by(&:length).last[0]
    end
  end
  
  def handle_response(letter=nil, new_board)
    if letter != nil && new_board.empty? == false
      @dictionary = @dictionary.select{|x| x.chars.each_index.select{|y| x[y] == letter} == new_board}
    elsif letter != nil 
      @dictionary = @dictionary.reject{|word| word.include?(letter)}
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Let's play Hangman!\n"
  puts "Do you want to be the one to decide on the word and have 
the computer guess? (yes or no)"
  answer = gets.chomp
  
  if answer.include?("y")
    puts "Ok, computer will guess."
    puts "Press enter to play:"
    gets
    #guesser = ComputerPlayer.with_dictionary_file("dictionary.txt")
    guesser = ComputerPlayer.with_dictionary_file("a_words.txt")
    referee = HumanPlayer.new
    game = Hangman.new({:guesser=>guesser, :referee=>referee})
    game.play
  else
    puts "Ok, computer will think of a word."
    puts "Press enter to play:"
    gets
    guesser = HumanPlayer.new
    referee = ComputerPlayer.with_dictionary_file("dictionary.txt")
    game = Hangman.new({:guesser=>guesser, :referee=>referee})
    game.play
  end
end
  