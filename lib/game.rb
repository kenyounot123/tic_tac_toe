
require_relative 'board'
require_relative 'players'

class Game
  attr_accessor :game_board
  def initialize
    @game_board = Board.new()
    @winner = 0
    @tie = 0 
  end

  def game_start
    assign_player_one
    assign_player_two
    @game_board.display_board
    game_loop
  end

  def assign_player_one
    puts "Enter player 1 name: "
    @player_one = Players.new(gets.chomp, 'X')
  end

  def assign_player_two
    puts "Enter player 2 name: "
    @player_two = Players.new(gets.chomp, 'O')
  end

  def game_over #game over when there is a tie or winner
    if @game_board.three_in_a_row?
      @winner = 1
      puts "#{@current_player.name} is the winner!"
    elsif @game_board.space_left? && @winner == 0 
      @tie = 1 
      puts "It's a Tie!"
    end
  end
    

  def game_loop
    puts "Welcome to my Tic-Tac-Toe game"
    for i in (1..9)  #9 turns max in tic tac toe
      if i.even? 
        @current_player = @player_two
      else
        @current_player = @player_one
      end
      puts "#{@current_player.name} please pick your move"
      space = gets.chomp.to_i
      valid_move = validate_player_move(space)
      @game_board.update_board(valid_move, @current_player.symbol)
      game_over  
      break if @winner == 1 
    end
  end

  def validate_player_move(space)
    until @game_board.space_available?(space) && (space.between?(1,9)) do
      puts "Space not available, please choose again"
      space = gets.chomp.to_i
    end
    space
  end
end

