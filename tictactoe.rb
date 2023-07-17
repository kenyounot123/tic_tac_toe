
#Tic tac toe
#Game board will be a 3x3 board  , 3 by 3 array 
# [1 , 2 , 3]
# [4 , 5 , 6]
# [7 , 8 , 9]

# players will pick their move based on the numbers , when picked , number will turn into O or X 
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
    ---+---+---
    #{@board[3]} | #{@board[4]} | #{@board[5]}
    ---+---+---
    #{@board[6]} | #{@board[7]} | #{@board[8]}
    \n"
  end

end
  
class Players
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end


class Game 
  attr_reader :board, :player_one, :player_two
  def initialize
    @game_board = Board.new()
    @winner = 0
    game_start
  end

  def game_start 
    puts "Welcome to my Tic-Tac-Toe game"
    assign_player_one
    assign_player_two
    @game_board.display_board
  end

  def assign_player_one
    puts "Enter player one name: "
    @player_one = Players.new(gets.chomp, 'X')
  end

  def assign_player_two
    puts "Enter player two name: "
    @player_two = Players.new(gets.chomp, 'O')
  end

end

