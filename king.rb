require "./chess_piece.rb"
class King < ChessPiece
  include SteppingPiece
  attr_reader :deltas

  def initialize(color, board)
    super(color, board)
    @deltas = [
      [1, 1], [1, -1], [1, 0], [-1, 1], [-1, -1], [-1, 0], [0, 1], [0, -1]
    ]
  end
end