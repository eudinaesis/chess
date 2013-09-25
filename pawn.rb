require "./chess_piece.rb"

class Pawn < ChessPiece
  #curently does not allow first move of two spaces for a pawn

  def has_moved?(pos)
    case self.color
    when :white then return pos[0] == 6
    when :black then return pos[0] == 1
    end
  end

  def is_legal?(old_pos, new_pos)
    return false if Board::off_board?(new_pos)
    is_legal_step?(old_pos, new_pos, has_moved?(old_pos)) || is_legal_capture?(old_pos, new_pos)
  end

  def is_legal_step?(old_pos, new_pos, optional_two)
    available_steps(old_pos, optional_two).include?(new_pos)
  end

  def available_steps(old_pos, optional_two)
    color_direction = { :white => -1, :black => 1 }
    deltas = [1 * color_direction[self.color]]
    deltas << (2 * color_direction[self.color]) if optional_two

    steps = deltas.map do |delta|
      [old_pos[0] + delta, old_pos[1]]
    end
    available_steps = steps.select.with_index do |position, index|
      @board[position] == nil && @board[steps[0]] == nil
    end
  end

  def available_captures(old_pos)
    color_direction = { :white => -1, :black => 1 }
    deltas = [
      [1 * color_direction[self.color], 1],
      [1 * color_direction[self.color], -1]
    ]

    captures = deltas.map do |delta|
      [old_pos[0] + delta[0], old_pos[1] + delta[1]]
    end
    available_captures = captures.select do |position|
      @board[position] != nil && @board[position].color != self.color
    end
  end

  def is_legal_capture?(old_pos, new_pos)
    available_captures(old_pos).include?(new_pos)
  end

  def possible_moves(loc)
    available_captures(loc) + available_steps(loc, has_moved?(loc))
  end
end