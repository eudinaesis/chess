module SteppingPiece
  def is_legal?(old_pos, new_pos)
    legal_destinations = @deltas.map do |delta|
      [old_pos[0] + delta[0], old_pos[1] + delta[1]]
    end
    legal_destinations.include?(new_pos)
  end

end