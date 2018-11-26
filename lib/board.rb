class Board
  attr_accessor :cells
   def initialize
    self.reset!
  end
   def reset!
    @cells = Array.new(9, " ")
  end
   def display
    row_border = "-----------"
    puts format_row(0)
    puts row_border
    puts format_row(3)
    puts row_border
    puts format_row(6)
  end

  def format_row(index)
    " #{@cells[index]} | #{@cells[index + 1]} | #{@cells[index + 2]} "
  end

  def position(index)
    @cells[index.to_i - 1]
  end

  def full?
    #!@cells.any? {|cell| cell == "" || cell == " " || cell == nil}
    !@cells.any? {|cell| cell == " "}
  end

  def turn_count
    @cells.select{|cell| cell != " "}.count
  end

  def taken?(index)
    @cells[index.to_i - 1] != " "
  end

  def valid_move?(cell_number)
    index = cell_number.to_i - 1
    index >= 0 && index <= 8 && !self.taken?(cell_number)
  end

  def update(cell_number, player)
    @cells[cell_number.to_i - 1] = player.token
  end
end
