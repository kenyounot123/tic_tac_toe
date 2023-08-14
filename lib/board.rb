
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