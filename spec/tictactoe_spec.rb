require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/players'


describe Game do 
  subject(:game) { described_class.new }
  describe '#game_start' do 
    before do
      game.instance_variable_set(:@game_board, instance_double(Board))
    end
    
    it 'sets up game players and board' do
      allow(game).to receive(:assign_player_one)
      allow(game).to receive(:assign_player_two)
      allow(game).to receive(:game_loop)
      expect(game.game_board).to receive(:display_board)
      game.game_start
    end
  end

  describe '#assign_player_one' do
    it 'creates player one' do
      player_name = 'bob'
      player_symbol = 'X'
      allow(game).to receive(:puts)
      allow(game).to receive(:gets).and_return(player_name)
      expect(Players).to receive(:new).with(player_name, player_symbol)
      game.assign_player_one
    end  
  end

  describe '#game_over' do
    before do
      game.instance_variable_set(:@game_board, instance_double(Board))
      game.instance_variable_set(:@current_player, instance_double(Players))
      current_player = game.instance_variable_get(:@current_player)
      allow(current_player).to receive(:name)
    end
    it 'sends three_in_a_row message to board' do
      board = game.instance_variable_get(:@game_board)
      allow(board).to receive(:three_in_a_row?).and_return(true)
      allow(game).to receive(:puts)
      expect(board).to receive(:three_in_a_row?)
      game.game_over
    end
    
    it 'sends space_left? message to board' do
      board = game.instance_variable_get(:@game_board)
      allow(board).to receive(:three_in_a_row?).and_return(false)
      allow(game).to receive(:puts)
      expect(board).to receive(:space_left?)
      game.game_over
    end
  end

  describe '#validate_player_move' do
    before do
      game.instance_variable_set(:@game_board, instance_double(Board))
    end
    context 'when given a valid move as argument and space_available? is true' do
      it 'returns valid move' do
        board_space = game.instance_variable_get(:@game_board)
        allow(board_space).to receive(:space_available?).and_return(true)
        user_input = 7
        valid_move = game.validate_player_move(user_input)
        expect(valid_move).to eq(7)
      end
    end

    context 'when given invalid move as argument or space_available? is false' do
      it 'retries until a valid move is given' do 
        board_space = game.instance_variable_get(:@game_board)
        allow(board_space).to receive(:space_available?).and_return(true)
        allow(game).to receive(:gets).and_return('invalid\n', '3\n')
        result = nil
    
        # Capture stdout temporarily
        original_stdout = $stdout
        $stdout = StringIO.new
        
        begin
          result = game.validate_player_move(30)
        ensure
          $stdout = original_stdout  # Restore original stdout
        end
      end
    end
  end

  # describe '#game_loop' do
  #   let(:board) { instance_double(Board) }
  #   let(:player_one) { instance_double(Players, name: 'Alice', symbol: 'X') }
  #   let(:player_two) { instance_double(Players, name: 'Bob', symbol: 'O') }
  #   let(:game_board) { instance_double(Board) }
  #   before do
  #     allow(game).to receive(:puts)  # Suppress output during testing
  #   end

  #   it 'plays the game loop and handles different scenarios' do
  #     # Setup expectations and stubs here
  #     # Test player turns, input validation, board updates, game over conditions, loop breaking, etc.
  #     allow(player_one).to receive(:name).and_return('Alice')
  #     allow(player_two).to receive(:name).and_return('Bob')


  #     # Expect the final "Play again?" prompt
  #     expect { game.game_loop }.to output("Play again?\n").to_stdout
  #   end
  # end
end

describe Board do 

  subject(:game_board) { described_class.new }

  describe '#initialize' do
    it 'creates an array with correct values' do
      correct_board = [1,2,3,4,5,6,7,8,9]
      new_board = game_board.instance_variable_get(:@board)
      expect(new_board).to eq(correct_board)
    end
  end

  describe '#space_available?' do
    context 'when given a space to check as its argument' do
      it 'returns true if there is space' do
        current_board = ['O','X','X',4,5,6,7,8,9]
        our_board = game_board.instance_variable_set(:@board, current_board)
        expect(game_board.space_available?(7)).to be(true)
      end
      it 'returns false if there is no space' do
        current_board = ['O','X','X',4,5,6,7,8,9]
        our_board = game_board.instance_variable_set(:@board, current_board)
        expect(game_board.space_available?(2)).to be(false)
      end
    end
  end

  describe '#space_left?' do
    it 'returns true if all spaces on the board are taken' do
      current_board = ['O','X','X','X','X','O','O','O','X']
      our_board = game_board.instance_variable_set(:@board, current_board)
      expect(game_board.space_left?).to be(true)
    end
    it 'returns false if there are still empty spaces on the board' do
      current_board = ['O','X','X','X','X','O','O','O',9]
      our_board = game_board.instance_variable_set(:@board, current_board)
      expect(game_board.space_left?).to be(false)
    end
  end

  describe '#update_board' do 
    before do
      allow(game_board).to receive(:display_board) 
    end
    it 'updates the board with correct symbol' do
      board_area = 1
      update_with_symbol = 'X'
      game_board.update_board(board_area, update_with_symbol)
      our_board = game_board.instance_variable_get(:@board)
      expect(our_board[0]).to eq('X')
    end

    it 'displays updated board' do
      expect(game_board).to receive(:display_board)
      game_board.update_board(2, 'O')
    end
  end

  describe '#three_in_a_row?' do
    context 'when win conditions are satisfied' do
      it 'returns true when there is three in a row horizontally' do
        win_condition = ['X','X','X',4,5,6,7,8,9]
        game_board.instance_variable_set(:@board, win_condition)
        expect(game_board.three_in_a_row?).to be(true) 
      end
      it 'returns true when there is three in a row diagonally' do 
        win_condition = ['X',2,3,4,'X',6,7,8,'X']
        game_board.instance_variable_set(:@board, win_condition)
        expect(game_board.three_in_a_row?).to be(true)
      end
      it 'returns true when there is three in a row vertically' do 
        no_win_condition = ['X',2,3,'X',5,6,'X',8,9]
        game_board.instance_variable_set(:@board, no_win_condition)
        expect(game_board.three_in_a_row?).to be(true)
      end
    end

    context 'when win conditions are not met' do
      it 'returns false' do
        no_win_condition = [1,2,3,4,5,6,7,8,9]
        game_board.instance_variable_set(:@board, no_win_condition)
        expect(game_board.three_in_a_row?).to be(false)
      end
    end
  end
end
