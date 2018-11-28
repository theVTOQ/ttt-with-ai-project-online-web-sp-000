class Players::Computer < Player
  def move(board)
    move = get_move(board)
    return (move == nil) ? nil : (move.to_i + 1).to_s
  end

  def get_move(board)
    turns_played = board.turn_count
    if turns_played == 0
      #if starting the game, choose the middle cell so as to maximize
      #winning chances
      return 4
    elsif turns_played == 1 && board.taken?("5")
      #the first move has been played, and the middle cell was occupied;
      #now, must randomly choose a cell that is both on a diagonal
      #and the end of a row to mazimizez our winning chances
      diagonal_edges = [0,2,6,8]
      return diagonal_edges[rand(diagonal_edges.size)]
    elsif turns_played == 8
      #there is only one playable cell, so play it and skip the
      #remaining logic in this method
      final_cell = board.cells.detect{|cell| cell == " "}
      return final_cell
    end

    remaining_winning_indices = []
    loss_prevention_indices = []
    opposite_token = @token == "X" ? "O" : "X"

    Game::WIN_COMBINATIONS.each do |combo|
      opp_indices = []
      my_indices = []
      unclaimed_indices = []
      #number of cells in this combo occupied by other player:
      opp_total = 0 #combo.select{|cell| cell == opposite_token}.count
      #number of cells in this combo I have occupied
      my_total = 0 #combo.select{|cell| cell == opposite_token}.count
      #number of cells in this combo that have not been occupied
      total_unclaimed = 0 #3 - opp_total - my_total

      combo.each do |index|
        case board.cells[index]
        when " "
          total_unclaimed += 1
          unclaimed_indices << index
        when @token
          my_total += 1
          my_indices << index
        else
          opp_total += 1
          opp_indices << index
        end
      end

      if my_total == 2 && total_unclaimed == 1
        #if I have 2 of the three cells in this combo occupied,
        #and the remaining cell is empty, must fill that cell
        return unclaimed_indices[0] #combo.detect{|index| board[index] == " "}
      elsif opp_total == 2 && total_unclaimed == 1
        #if opposite player has 2 of the three cells in this combo occupied,
        #and the remaining cell is empty, will have to fill that cell later
        #if exhaust potential winning moves
        loss_prevention_indices << unclaimed_indices[0]  #combo.detect{|index| board[index] == " "}
      elsif opp_total == 0
        #if opponent has not occupied any cells in this combo,
        #add all empty indices to remaining_winning_indices
        remaining_winning_indices.concat(unclaimed_indices)
      end
    end

    #at this point, no winning move has been playable; next priority is to prevent
    #opponent from winning, if opponent is one move away from winning
    if loss_prevention_indices.size > 0
      return loss_prevention_indices[0]
    end

    #at this point, neither of us are one move away from a win;
    #if there are no remaining winning moves, choose a valid move randomly
    if remaining_winning_indices.size == 0
      valid_moves = board.cells.select{|cell| cell == " "}
      return valid_moves[rand(valid_moves.size)]
    end

    ##if there are remaining winning moves,
    #choose the empty index that occurs in the most winning combinations,
    occurences = {} #hash to keep track of occurences of indices in winning combos
    indices_with_most_occurences = [] #array to contain indices that are tied for the most occurences
    most_occurences = 0 #the highest number of occurences so far

    #cycle through each remaining winning index, and keep track of how often each index occurs
    remaining_winning_indices.each do |index|
      existing_occurences = occurences[index]
      #if index is not yet tracked in occurences hash, add it
      if existing_occurences == nil
        occurences[index] = 1
      else
        occurences[index] = existing_occurences + 1 #new occurence total
        if occurences[index] > most_occurences
          #if this index now has the most occurences:
          most_occurences = occurences[index]
          indices_with_most_occurences = [index]
        elsif occurences[index] == most_occurences
          #if this index is tied for the most occurences:
          indices_with_most_occurences << index
        end
      end
    end

    #randomly choose an index from among those with the most occurences in
    #the remaining possible winning combinations
    return indices_with_most_occurences[rand(indices_with_most_occurences.size)]
  end
end
