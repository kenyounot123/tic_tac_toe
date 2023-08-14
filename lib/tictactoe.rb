
#Tic tac toe
#Game board will be a 3x3 board  , 3 by 3 array 
# [1 , 2 , 3]
# [4 , 5 , 6]
# [7 , 8 , 9]
#game loop :
#   players will pick their move based on the numbers , when picked , number will turn into O or X 
#   this will loop until a winner is decided or if there is a tie
#when game object is initialized
# game board is generated , players are assigned

#Classes : game , players, board
#players are initialized with name and symbol assigned
require "pry-byebug"

class Board

  def initialize
    @board = Array.new(9) { |i| i + 1}
  end

  def display_board
    puts "\n
    #{@board[0]} | #{@board[1]} | #{@board[2]}
    --+---+--
    #{@board[3]} | #{@board[4]} | #{@board[5]}
    --+---+--
    #{@board[6]} | #{@board[7]} | #{@board[8]}
    \n"
  end

  def three_in_a_row? #determine if there is a winner
    win_condition = false
    for row in (0..6).step(3)
      if @board[row] == @board[row + 1] && @board[row] == @board[row + 2]
        win_condition = true
        break
      end
    end

    for column in (0..2)
      if @board[column] == @board[column + 3] && @board[column] == @board[column + 6] 
        win_condition = true
        break
      end
    end
    #diagonals
    if (@board[0] == @board[4] && @board[0] == @board[8]) ||
       (@board[2] == @board[4] && @board[2] == @board[6])
      win_condition = true
    end
    return win_condition
  end

  def update_board(space, symbol)
    @board[space.to_i - 1] = symbol
    display_board
  end

  def space_available?(space_to_be_checked)
    board_space = @board[space_to_be_checked - 1].to_s
    if board_space.include?("X") || board_space.include?("O")
      return false
    else
      return true
    end
  end

  def space_left? #game over when there is a tie or winner
    no_space_left = @board.all? do |space|
      space.to_s.include?("X") || space.to_s.include?("O")
    end
    return no_space_left
  end

end
  
class Players
  attr_accessor :name, :symbol
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @current_player = ''
  end
end


class Game
  attr_accessor :game_board
  def initialize
    @game_board = Board.new()
    @winner = 0
    @tie = 0 
    game_start
  end

  def game_start 
    puts "Welcome to my Tic-Tac-Toe game"
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

  def game_over? #game over when there is a tie or winner
    if @game_board.three_in_a_row?
      @winner = 1
      puts "#{@current_player.name} is the winner!"
    end
    if @game_board.space_left? && @winner == 0 
      @tie = 1 
      puts "It's a Tie!"
    end
  end
    

  def game_loop
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
      game_over?  
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

new_game = Game.new()
