# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

class Game
  def initialize playernames
    @players = playernames.collect { |name| player = Player.new(name)}
    @dice = DiceSet.new
    @scorer = Scorer.new
    @turn = 1
  end

  def start
    puts "Welcome to GREED!"
    @players.each { |player| puts "#{player.to_str}" }

    while ((@players.select { |player| player.score >= 3000 }) == [])
      round()
    end

    # final turn!

    round()

    winner = @players.max_by { |player| player.score }

    puts "The winner is #{winner.to_str}"
  end

  def round
    puts "======================================="
    puts "======================================="
    puts "======================================="
    puts "New round. Scores as follows:"
    @players.each { |player| puts "#{player.to_str}" }
    puts "======================================="
    puts "======================================="
    puts "======================================="

    @players.each { |player| turn(player) }
    @turn += 1
  end

  def turn player
    puts "======================================="
    puts "#{player.name}'s turn"
    puts "======================================="

    score = 0
    num_dice = 5

    loop do
      values = @dice.roll(num_dice)
      roll_score = @scorer.score(values)
      scoring_count = @scorer.scoring(values)
      score += roll_score

      puts "#{player.name} rolls #{values}"

      # if player scores zero on a roll, set score to zero
      if (roll_score == 0)
        hurl_abuse()

        score = 0
        break
      end

      puts "worth #{roll_score}. Turn total: #{score}"
      puts "#{scoring_count} die were scoring, leaving #{num_dice - scoring_count} non scoring die"

      # update number of die for next roll (unless all 5 scored, then you can roll again)

      if scoring_count != 5
        num_dice -= scoring_count
      end

      if (num_dice == 0 || ask_roll() == false)
        break
      end
    end

    if player.in_the_game
      player.score += score
    else
      if (score >= 300)
        player.in_the_game = true
        player.score += score
      end
    end

    player
  end

  def ask_roll
    puts "would you like to roll again? y/n"
    again = gets

    if (again == "y\n")
      return true
    elsif (again == "n\n")
      return false
    else
      puts "Please enter y or n"
      ask_roll()
    end
  end

  private

  def hurl_abuse
    puts "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
    puts "⠀⠀⠀⠹⣷⡀⣰⡿⠁⢀⣾⠟⠛⢿⣶⡀⢸⣿⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀"
    puts "⠀⠀⠀⠀⠙⣿⡟⠁⠀⢸⣿⠀⠀⢀⣿⡇⢸⣿⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀"
    puts "⠀⠀⠀⠀⠀⣿⡇⠀⠀⠈⠻⢷⣶⡾⠟⠀⠈⠻⣷⣶⡿⠏⠀⠀⠀⠀⠀⠀⠀⠀"
    puts "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
    puts "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
    puts "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
    puts "⠀⠀⠀⣰⡞⠛⠿⠦⠀⢸⣿⠀⠀⣿⣿⠀⣠⣾⠿⠿⣶⡀⢸⣿⠀⣠⣾⠟⠀⠀"
    puts "⠀⠀⠀⠘⠻⠷⣶⣤⠀⢸⣿⠀⠀⣿⣿⠀⣿⡇⠀⠀⠀⠀⢸⣿⣿⢿⣧⠀⠀⠀"
    puts "⠀⠀⠀⠲⣧⣤⣼⠿⠀⠸⢿⣦⣴⡿⠃⠀⠹⢿⣤⣴⡿⠁⢸⣿⠁⠈⢿⣷⡀⠀"
  end
end

class Player
  attr_accessor :score, :in_the_game
  attr_reader :name

  def initialize name
    @name = name
    @score = 0
    @in_the_game = false
  end

  def to_str
    @name + ": " + @score.to_s
  end
end

class Scorer
  def score(dice)
    counts = Hash.new(0)

    dice.each do |value|
      counts[value] += 1
    end

    score = 0

    counts.each do |roll, count|
      if count >= 3
        if roll == 1
          score += 1000
        else
          score += (roll * 100)
        end
        count -= 3
      end

      if roll == 1
        score += (count * 100)
      elsif roll == 5
        score += (count * 50)
      end
    end
    score
  end

  def scoring(dice)
    counts = Hash.new(0)

    dice.each do |value|
      counts[value] += 1
    end

    scoring = 0

    counts.each do |roll,count|
      if count >= 3
        scoring += 1
        count -= 3
      end

      if roll == 1 || roll == 5
        scoring += count
      end
    end

    scoring
  end
end

class DiceSet
  attr_reader :values

  def roll(num)
    @values = (1..num).collect { |n| n = rand(1..6) }
  end

end

# main: start game

game = Game.new(["Iain", "Tania", "Anita", "Gen"])
game.start
