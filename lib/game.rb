class Game
  WIN_COMBINATIONS = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [6,4,2]
  ]

  attr_accessor :board, :player_1, :player_2

  def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
  end

  def play
    while !self.over?
      self.turn
    end

    @board.display
    if self.draw?
      puts "Cat's Game!"
    elsif self.won?
      puts "Congratulations #{self.winner}!"
    end
  end

  def turn
    #num = current_player == @player_1 ? "1" : "2"
    #puts "Player #{num}, choose a cell number:"
    @board.display
    cell_number = current_player.move(@board)
    if @board.valid_move?(cell_number.to_s)
      @board.update(cell_number, current_player)
    else
      turn
    end
  end

  def current_player
    @board.turn_count.odd? ? @player_2 : @player_1
  end

  def won?
    cells = @board.cells
    WIN_COMBINATIONS.each do |combo|
      pos_1 = cells[combo[0]]
      pos_2 = cells[combo[1]]
      pos_3 = cells[combo[2]]
       x_wins = pos_1 == "X" && pos_2 == "X" && pos_3 == "X"
      y_wins = pos_1 == "O" && pos_2 == "O" && pos_3 == "O"
      #binding.pry
      if x_wins || y_wins
        return combo
      end
    end
    false
  end

  def draw?
    @board.full? && !self.won?
  end

  def over?
    self.draw? || self.won?
  end

  def winner
    win_combo = self.won?
    if win_combo == false
      return nil
    end
    @board.cells[win_combo[0]]
  end
end
