#!/usr/bin/ruby
class GamePlay < GreedGame
    $user_outcome = ""
    @@sleep_time = 1.25
    def initialize
        @game
    end
    
    def round(player)
        player_set = DiceSet.new
        player_roll = player_set.roll(5)
        puts "#{player} rolls #{player_roll.join(", ")}."
        sleep(@@sleep_time)
        times_rolled = 1
        player_score = player_set.score[0]
        last_roll_score = player_score
        puts "#{player}'s score is #{player_score}."
        sleep(@@sleep_time)
        
        # if it's the first roll and player didn't have non-scoring dice,
        # player has hot dice and can roll again without fear of losing overall score
        if  times_rolled == 1 && player_set.score[1] == 0
            puts "#{player} rolled hot dice! #{player} can roll again!"
            sleep(@@sleep_time)
            new_set = DiceSet.new
            new_roll = new_set.roll(5)
            puts "#{player} now rolls #{new_roll.join(", ")}."
            sleep(@@sleep_time)
            new_score = new_set.score[0]
            puts "This roll's score is #{new_score}."
            new_score = new_set.score[0] + player_score
            times_rolled += 1
            puts "#{player}'s score is now #{new_score} after #{times_rolled} rolls."
            if new_set.score[1] == 1
                puts "#{player} had only 1 non-scoring die this roll,"
                puts "so #{player} doesn't have the option to roll again."
            end
            sleep(@@sleep_time)
        # if it's first roll and player didn't get any scoring dice,
        # player can roll again for free
        elsif times_rolled == 1 && player_set.score[0] == 0
            puts "Since #{player}'s score is 0 on the first roll, they can roll again."
            sleep(@@sleep_time)
            player_set = DiceSet.new
            player_roll = player_set.roll(5)
            puts "#{player} now rolls #{player_roll.join(", ")}."
            sleep(@@sleep_time)
            player_score = player_set.score[0]
            last_roll_score = player_score
            times_rolled += 1
            if player_score == 0
                puts "Round 2 didn't work out for #{player}! Moving on!"
                sleep(@@sleep_time)
            else
                puts "#{player}'s score is now #{player_score} after #{times_rolled} rolls."
                sleep(@@sleep_time)
            end
            if player_set.score[1] == 1
                puts "#{player} had only 1 non-scoring die this roll,"
                puts "so #{player} doesn't have the option to roll again."
                sleep(@@sleep_time)
            end
        end
        
        if times_rolled == 1 && player_set.score[1] == 1
            puts "#{player} had only 1 non-scoring die this roll,"
            puts "so #{player} doesn't have the option to roll again."
            sleep(@@sleep_time)
        end
        
        while (times_rolled < $chances_total) && (last_roll_score != 0) && (player_set.score[1] > 1)
            puts "#{player} has the option to roll again..."
            puts "#{player} will be using #{player_set.score[1]} dice if they roll again."
            choices = ["yes", "yes", "no"]
            if player == $user_player
                puts "Does #{player} want to take a chance and roll again?"
                puts "(yes or no)"
                decision = gets.chomp.downcase
            else
                decision = choices.sample
            end
            
            dice_number = player_set.score[1]
                
            if decision == "yes" || decision.empty?
                puts "#{player} decided to roll again!"
                sleep(@@sleep_time)
                player_score = last_roll_score
                player_set = DiceSet.new
                player_roll = player_set.roll(dice_number)
                puts "#{player} now rolls #{player_roll.join(", ")}"
                sleep(@@sleep_time)
                player_score = player_set.score[0]
                if player_score == 0
                    puts "Oh no! #{player} didn't roll any scoring dice!"
                    puts "#{player}'s score for the round is 0!"
                    sleep(@@sleep_time)
                    last_roll_score = player_score
                else 
                    times_rolled += 1
                    player_score += last_roll_score
                    last_roll_score = player_score
                    puts "#{player}'s score is now #{player_score} after #{times_rolled} rolls."
                    if dice_number == 1
                        puts "#{player} had only 1 non-scoring die this roll,"
                        puts "so #{player} doesn't have the option to roll again."
                        puts " "
                    end
                    sleep(@@sleep_time)
                end
            else
                puts "#{player} has decided not to be greedy, and won't be rolling again."
                sleep(@@sleep_time)
                break
            end
        end
        
        [player, player_score]
    end
    
    def winner(round)
       best_score = round.sort_by{|set| set[1]}
       best_score = best_score.select{|set| set[1] == best_score.last[1]}
       winners = best_score.flatten.select{|entry| entry.is_a?(String)}
       best_score = best_score.flatten.reject{|item| item.is_a?(String)}[0]
       if winners.length == 1
           [winners[0], best_score]
       else 
           [winners, best_score]
       end
    end
    
    def round_name(num)
        hash = {1 => "first", 2 => "second", 3 => "third", 4 => "fourth", 5 => "fifth",
            6 => "sixth", 7 => "seventh", 8 => "eigth", 9 => "ninth", 10 => "tenth"}
        hash[num]
    end
    
    def playing
        @@round_winners = []
        while @@round_winners.length < $round_total
            new_round = []
            puts "This is the #{round_name(@@round_winners.length + 1)} round!"
            puts "You start the round."
            sleep(@@sleep_time)
            new_round << round($user_player)
            $players.each do |player|
                puts "Now it's #{player}'s turn."
                sleep(@@sleep_time)
                new_round << round(player)
            end
            @@round_winners << winner(new_round)
            if @@round_winners.last.flatten.length == 2
                puts "#{@@round_winners.last[0]} wins the round, with #{@@round_winners.last[1]} points!"
                puts " "
                sleep(@@sleep_time)
            elsif @@round_winners.last.flatten.length == 4
                tied_score = @@round_winners.last[1]
                winners = @@round_winners.last[0]
                puts "#{winners.join(" and ")} tie for the round at #{tied_score} points!"
                puts " "
                sleep(@@sleep_time)
            else
                tied_score = @@round_winners.last[1]
                winners = @@round_winners.last[0]
                puts "#{winners.join(", ")} tie for the round at #{tied_score} points!"
                puts " "
                sleep(@@sleep_time)
            end
        end
    end
    
    def scoring
       total = @@round_winners.flatten.reject{|item| item.is_a?(Fixnum)}
       total = total.sort_by{|name| total.count(name)}
       total = total.select{|name| total.count(name) == total.count(total.last)}.uniq
       if total.length == 1
           puts "#{total.join} wins!!!"
           total.include?($user_player) ? $user_outcome = "won" : $user_outcome = "lost"
       elsif total.length == 2
           puts "#{total.join(" and ")} tie!!!"
           total.include?($user_player) ? $user_outcome = "won" : $user_outcome = "lost"
       else
           puts "#{total.join(", ")} all tie!!!"
           total.include?($user_player) ? $user_outcome = "won" : $user_outcome = "lost"
       end
    end
end