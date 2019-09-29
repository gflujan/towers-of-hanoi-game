#!/Volumes/galvatron/gabriel/.rbenv/shims/ruby 

# Towers of Hanoi
#
# Write a Towers of Hanoi game:
# http://en.wikipedia.org/wiki/Towers_of_hanoi
#
# In a class `TowersOfHanoi`, keep a `towers` instance variable that is an array
# of three arrays. Each subarray should represent a tower. Each tower should
# store integers representing the size of its discs. Expose this instance
# variable with an `attr_reader`.
#
# You'll want a `#play` method. In a loop, prompt the user using puts. Ask what
# pile to select a disc from. The pile should be the index of a tower in your
# `@towers` array. Use gets
# (http://andreacfm.com/2011/06/11/learning-ruby-gets-and-chomp.html) to get an
# answer. Similarly, find out which pile the user wants to move the disc to.
# Next, you'll want to do different things depending on whether or not the move
# is valid. Finally, if they have succeeded in moving all of the discs to
# another pile, they win! The loop should end.
#
# You'll want a `TowersOfHanoi#render` method. Don't spend too much time on
# this, just get it playable.
#
# Think about what other helper methods you might want. Here's a list of all the
# instance methods I had in my TowersOfHanoi class:
# * initialize
# * play
# * render
# * won?
# * valid_move?(from_tower, to_tower)
# * move(from_tower, to_tower)
#
# Make sure that the game works in the console. There are also some specs to
# keep you on the right track:
#
# ```bash
# bundle exec rspec spec/towers_of_hanoi_spec.rb
# ```
#
# Make sure to run bundle install first! The specs assume you've implemented the
# methods named above.

class TowersOfHanoi 
  attr_reader :towers; 

  def initialize() 
    # --------------------------------------------- 
    #  Using a static board w/ a fixed number of discs 
    # --------------------------------------------- 
    # @towers = [ 
    #   [3,2,1], 
    #   [], 
    #   [], 
    # ]; 

    # @num_discs = @towers[0].length(); 

    # --------------------------------------------- 
    # Creating a dynamic "board" for the player 
    # --------------------------------------------- 
    @towers = Array.new(rand(3..6),[]); 
    @num_discs = rand(3..6); 
    (1..@num_discs).each() { |num| @towers[0] = [num] + @towers[0] }; 
  end 

  def play() 
    puts 
    puts 'Here are your starting towers:'; 
    render(); 

    # in a loop, prompt the user using "puts" & "gets" 
      # "What pile would you like to select a disk from?" 
    until won? 
      puts 
      puts 'What tower would you like to take a disc from?'; 
      from_tower_answer = gets.chomp(); 
      puts 'What tower would you like to move this disc to?'; 
      to_tower_answer = gets.chomp(); 

      # submit a check for a valid_move? 
      # if we're good, submit the move 
      # if not, puts an error and re-prompt the user for new selections 
        # does this mean I should put the prompt commands into their own method? 
      # once we have a valid move, render the output for the user 

      from_tower = from_tower_answer.to_i() - 1; 
      to_tower = to_tower_answer.to_i() - 1; 
      if from_tower_answer.empty?() || to_tower_answer.empty?() 
        puts 
        render(); 
        puts 'Please enter values for both towers that you want.'; 
      elsif valid_move?(from_tower, to_tower) 
        puts 
        move(from_tower, to_tower); 
        render(); 
        puts "That's a good move! Keep going!"; 
      else 
        puts 
        render(); 
        puts 'That is not a valid move! Please select new towers.'; 
      end 
    end 
  end 

  # --------------------------------------------- 
  #  PRIVATE METHODS 
  # --------------------------------------------- 
  private 

  def render() 
    # this is to render the output of the @towers array onto the console screen 
    # so that the user can see the moves they've made and the current state of the board 
    
    # This was used for the static 3x3 board 
    # print "Tower #01: #{@towers[0]}"; 
    # puts 
    # print "Tower #02: #{@towers[1]}"; 
    # puts 
    # print "Tower #03: #{@towers[2]}"; 
    # puts 

    @towers.each().with_index() do |tower, idx| 
      print "Tower ##{idx+1}: #{@towers[idx]}"; 
      puts 
    end 
  end 

  def move(from_tower, to_tower) 
    disc = @towers[from_tower].pop(); 
    @towers[to_tower] += [disc]; 

    if won? 
      render(); 
      play_again?(); 
    end 
  end 

  def valid_move?(from_tower, to_tower) 
    # I need to add another check to make sure that from_tower & to_tower 
    # are both valid numbers/positions of the current board 
    # (i.e.) they do not fall out of the bounds of the current array layout 
    return false if @towers[from_tower].empty?; 
    return true if @towers[to_tower].empty?; 
    disc1 = @towers[from_tower].last(); 
    disc2 = @towers[to_tower].last(); 
    disc1 > disc2 ? false : true; 
  end 

  def won?(state=false) 
    outcome = state; 

    @towers.each().with_index() do |tower, idx| 
      if tower.length() == @num_discs && idx != 0 && tower == tower.sort().reverse() 
        outcome = true; 
      end 
    end 

    return outcome; 
  end 

  def play_again?() 
    puts '*** CONGRATS! YOU JUST WON THE GAME! ***'; 
    puts 'Would you like to play another? (Yes or No?)'; 
    answer = gets.chomp().downcase(); 

    if answer == 'yes' 
      new_game = TowersOfHanoi.new(); 
      new_game.play(); 
    else 
      exit; 
    end 
  end 
end 

game = TowersOfHanoi.new(); 
game.play(); 

# --------------------------------------------- 
# FINAL NOTES & THOUGHTS 
# --------------------------------------------- 
# Ideally, when a player answers "yes" to play_again?, I'd like reset the current game instance 
# instead of having to create a new one 
  # (although, does that really matter from a memory/performance perspective?) 
# Another way that I could improve upon this is to randomize the number of starting discs and/or towers 
  # I would do this by using @towers = Array.new(rand_num, []); 
  # Then I would create a 2nd random generator and use that as the end of a range 
  # The range would be collection of "discs" (i.e. integers) to shovel onto the first tower 
# CHALLENGES: 
  # The random numbers for the towers and discs is sort of working 
  # However, there are times when I end up with 1 or 0 towers, I need to be able to set a min 
  # Also, for the discs, every "disc" is getting inserted onto every tower 
    # How do I make sure that the discs only get added to the first tower? 
# NOTES: 
  # Alright, solved the problems above, but now when I make a move, 
  # it's adding the disc onto every other tower, and not just the one I picked 
# Alright! I solved that last problem and everything is working the way I want it to. 
