module SteppingPiece
  def is_legal?(old_pos, new_pos)
    # new_pos_obj = @board.squares[new_pos[0]][new_pos[1]]
    # legal_destinations = @deltas.map do |delta|
#       [old_pos[0] + delta[0], old_pos[1] + delta[1]]
#     end.reject { |position| Board::off_board?(position) }
#     legal_destinations.include?(new_pos) &&
#     (new_pos_obj == nil || new_pos_obj.color != self.color)
    possible_moves(old_pos).include?(new_pos)
  end

  def possible_moves(location)
    all_steps = @deltas.map do |delta|
      [location[0] + delta[0], location[1] + delta[1]]
    end
    on_board_steps = all_steps.reject { |position| Board::off_board?(position) }
    available_steps = on_board_steps.reject do |position|
      @board.squares[position[0]][position[1]] != nil &&
      @board.squares[position[0]][position[1]].color == self.color
    end
  end
end