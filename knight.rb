# require "./chess_piece.rb"

class Knight < ChessPiece
  include SteppingPiece
  attr_reader :deltas

  def initialize(color, board)
    super(color, board)
    @deltas = [
      [-2, 1],
      [1, 2],
      [-1, -2],
      [2, -1],
      [-1, 2],
      [2, 1],
      [-2, -1],
      [1, -2]
    ]
  end
end