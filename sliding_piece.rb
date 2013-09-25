module SlidingPiece
  def is_legal?(old_pos, new_pos)
    new_pos_obj = @board.squares[new_pos[0]][new_pos[1]]

    legal_destinations(old_pos).include?(new_pos) &&
    (new_pos_obj == nil || new_pos_obj.color != self.color) &&
    no_piece_in_the_way?(old_pos, new_pos)
  end

  def no_piece_in_the_way?(old_pos, new_pos)
    delta_y = new_pos[0] <=> old_pos[0]
    delta_x = new_pos[1] <=> old_pos[1]

    path = []
    current_pos = old_pos
    until current_pos == new_pos
      current_pos = [current_pos[0] + delta_y, current_pos[1] + delta_x]
      path << current_pos
    end
    path.pop

    path.all? do |path_pos|
      @board.squares[path_pos[0]][path_pos[1]].nil?
    end
  end

  def legal_destinations(old_pos)
    legal_destinations = []
    @vectors.each do |vector|
      (1..8).each do |multiplier|
        new_pos = [old_pos[0] + (vector[0] * multiplier),
        old_pos[1] + (vector[1] * multiplier)]
        legal_destinations << new_pos unless Board::off_board?(new_pos)
      end
    end
    # if self.is_a?(Queen)
    #   puts "the #{self.color} queen's dests are #{legal_destinations}"
    # end
    legal_destinations
  end

  #IN PROGRESS. NOT COMPLETE!
  def possible_moves(location)
    # something that returns legal_destinations, minus blocked paths
    # print "legal dest are: #{legal_destinations(location)}\n"
    possible_moves = legal_destinations(location).select do |legal_move|
      # print "current legal move is #{legal_move}\n"
      legal_move_obj = @board.squares[legal_move[0]][legal_move[1]]
      no_piece_in_the_way?(location, legal_move) &&
        (legal_move_obj == nil || legal_move_obj.color != self.color) &&
        legal_move.all? { |coord| coord >= 0 && coord <= 8 }
    end

    possible_moves
  end
end