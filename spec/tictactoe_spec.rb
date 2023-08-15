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

  describe '#game_loop' do
    let(:board) { instance_double(Board) }
    before do

    end
    it 'play game_loop with valid moves' do
      player_one = instance_double(Players, name: 'Player 1', symbol: 'X')
      player_two = instance_double(Players, name: 'Player 2', symbol: 'O')
      game.instance_variable_set(:@player_one, player_one)
      game.instance_variable_set(:@player_two, player_two)
      allow(player_one).to receive(:gets).and_return("1\n")
      allow(player_two).to receive(:gets).and_return("5\n")
      allow(game).to receive(:validate_player_move).and_return(1, 5)
      allow(game).to receive(:game_over)
      expect(board).to receive(:update_board).twice
      game.game_loop
    end

    it 'should finish game if there is a tie' do
    end

  end
end
