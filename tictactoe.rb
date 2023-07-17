
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

  def update_board(space, symbol)
    @board[space.to_i - 1] = symbol
    @game_board.display_board
  end

  def space_available?(space_to_be_checked)
    board_space = @board[space_to_be_checked - 1].to_s
    if board_space.include?("X") || board_space.include?("O")
      return false
    else
      return true
    end
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

  def game_loop
    for i in (1..9)         #9 turns max in tic tac toe
      if i.even? 
        @current_player = @player_two
      else
        @current_player = @player_one
      end
      puts "#{@current_player.name} please pick your move"
      space = gets.chomp.to_i
      until @game_board.space_available?(space) && (space.between?(1,9)) do
        puts "Space not available, please choose again"
        space = gets.chomp.to_i
      end
      @game_board.update_board(space, @current_player.symbol)
    end
  end

end

