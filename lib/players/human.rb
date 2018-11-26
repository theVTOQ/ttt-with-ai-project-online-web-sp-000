module Players
  class Human < Player
    #binding.pry
    def move(board)
      puts "Which position would you like to take?"
      cell_number = gets
      cell_number
    end
  end
end
