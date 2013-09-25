require "./chess_piece.rb"

class Rook < ChessPiece
  include SlidingPiece
  attr_reader :vectors

  def initialize(color, board)
    super(color, board)
    @vectors = [
      [0, -1],
      [0, 1],
      [-1, 0],
      [1, 0]
    ]
  end
end