#!/usr/bin/ruby
class DiceSet < GamePlay
  def initialize
    @dice
  end
  
  def roll(num)
    returning = []
    num.times{returning << rand(1..6)}
    @dice = returning
  end
  
  def score
    dice = @dice
    dice = dice.sort
    result = 0
    
    if dice.select{|num| dice.count(num) >= 3}.length > 0
        triplet = dice.select{|x| dice.count(x) > 2}
        triplet_indexes = []
        dice.each_with_index do |num, i|
            triplet_indexes << i if triplet.include?(num)
        end
        while triplet_indexes.length > 3 
            triplet_indexes.delete(triplet_indexes.last)
        end
        triplet_indexes.each do |index|
            dice[index] = nil
        end
        dice = dice.compact
        if triplet[0] == 1
            result += 1000
        else
            result += triplet[0] * 100
        end
        if dice.include?(1)
            amount = dice.select{|num| num == 1}.length
            result += amount * 100
            dice = dice.reject{|num| num == 1}
            if dice.include?(5)
                amount = dice.select{|num| num == 5}.length
                result += amount * 50
                dice = dice.reject{|num| num == 5}
            end
        elsif dice.include?(5)
            amount = dice.select{|num| num == 5}.length
            result += amount * 50
            dice = dice.reject{|num| num == 5}
        end
    elsif dice.include?(1)
        amount = dice.select{|num| num == 1}.length
        result += amount * 100
        dice = dice.reject{|num| num == 1}
        if dice.include?(5)
            amount = dice.select{|num| num == 5}.length
            result += amount * 50
            dice = dice.reject{|num| num == 5}
        end
    elsif dice.include?(5)
        amount = dice.select{|num| num == 5}.length
        result += amount * 50
        dice = dice.reject{|num| num == 5}
    end
    [result, dice.length]
  end
end