#!/usr/bin/ruby
class GreedGame
    def welcome
        puts "   _____   _____    ______   ______   _____   "
		puts "  / ____| |  __ \\  |  ____| |  ____| |  __ \\  "
		puts " | |  __  | |__) | | |__    | |__    | |  | | "
		puts " | | |_ | |  _  /  |  __|   |  __|   | |  | | "
		puts " | |__| | | | \\ \\  | |____  | |____  | |__| | "  
		puts "  \\_____| |_|  \\_\\ |______| |______| |_____/  "
		puts " "
    end
    
    def rules
        puts "
        Greed is a dice game played by 2 or more players, using 
        regular dice. Players decide how many rounds they want 
        to play, then they take turns in each round. A player's
        turn consists of throwing 5 dice, then determining
        their score based on the resulting set of numbers. 

        Scoring:
        - if there are 3 of the same numbers in the set, that number 
          is multipled by 100 and added to the score. So 3 4s results 
          in 400, 3 5s results in 500, and so on; except 1s, which 
          result in 1000.
        - Aside from the triplet numbers, if the other numbers contain
          a 1, or are all 1s, the score adds 100 for each 1.
          If the other number or numbers contain a 5, or are all
          5s, the score adds 50 for each 5.
        - A single number can only be counted once in each set.
        
        After rolling the dice, the player can choose to take a chance
        and throw again the non-scoring dice. If throw #2 results 
        in more scoring dice, those values are added to their score. But
        if this new throw resuls in no scoring dice, their overall round 
        score is dropped to zero. If their score on throw #2 results in 
        some scoring and some non-scoring dice, they can choose again
        to throw the non-scoring dice for the chance to add to their
        round score, under the same caveat as before, as long as they have 
        at least 2 die to throw.
        
        Example:
        - Player A's first throw is [3, 1, 5, 4, 3].
        - Their score is 150 and their non-scoring dice are [3, 4, 3].
        - They take a chance to add to their score and throw again.
        - Their second throw results in [1, 4, 4] and their score
          rises to 250. 
        - They decide to throw a third time and get [2, 6]. 
        - Because this throw contained no scoring dice, their overall 
          score gets dropped to 0. 
        
        A player that gets all scoring dice on their first throw has 
        'hot dice' and can throw one more time without their score 
        coming into jeopardy. 
        
        At the end of each round, the player with the most points wins
        the round. At the end of the rounds, the player who won the most 
        rounds wins the game.
        "
    end
    
    def won
       puts ".     . .____   ___     . ."
       puts " \\   /  |      /   \\    | |"
       puts "  \\ /   |____  |___     | |"
       puts "   |    |          \\    | |"
       puts "   |    |____   ___/    O O"
       puts " "
       puts "Thanks for playing, #{$user_player} :)" 
       puts " "
    end
    
    def lost
        puts ".   . .___ .   . ._____.   ._____. . .      . .___       "
        puts "|\\  | |     \\ /     |         |    | |\\    /| |          "
        puts "| \\ | |---   X      |         |    | | \\  / | |---       "
        puts "|  \\| |___  / \\     |         |    | |  \\/  | |___ o o o "
        puts " "
        puts "Thanks for playing, #{$user_player} :)" 
        puts " "
    end
    
    def gameplay
       # welcome
       welcome
       puts "Shall we look at the rules? (yes or no)"
       answer = gets.chomp.downcase
       if answer == "yes"  
           rules 
       else
           puts "Ok, here we go!"
       end
       
       # user gets added to the game
       user = UserPlayer.new
       user.enters_game
       
       # other players get added
       user.introduce_others
       
       # number of rounds are established
       user.rounds
       
       # game starts:
       # for each round, player is introduced, player rolls, player gets score
       # round winner(s) announced
       # next round is called
       game = GamePlay.new
       game.playing
       
       # after all rounds, rounds are scored, winner announced
       game.scoring
       
       # goodbye
       if $user_outcome == "won"
           won
       else
           lost
       end
    end
end