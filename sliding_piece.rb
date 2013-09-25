module SlidingPiece
  def is_legal?(old_pos, new_pos)
    new_pos_obj = @board.squares[new_pos[0]][new_pos[1]]

    legal_destinations(old_pos, new_pos).include?(new_pos) &&
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

  def legal_destinations(old_pos, new_pos)
    legal_destinations = []
    @vectors.each do |vector|
      (1..8).each do |multiplier|
        legal_destinations << [old_pos[0] + (vector[0] * multiplier),
        old_pos[1] + (vector[1] * multiplier)]
      end
    end
    # if self.is_a?(Queen)
    #   puts "the #{self.color} queen's dests are #{legal_destinations}"
    # end
    legal_destinations
  end

  something that returns legal_destinations, minus blocked paths
end