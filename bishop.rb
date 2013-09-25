require "./chess_piece.rb"

class Bishop < ChessPiece
  include SlidingPiece
  attr_reader :vectors

  def initialize(color, board)
    super(color, board)
    @vectors = [
      [-1, -1],
      [1, 1],
      [-1, 1],
      [1, -1]
    ]
  end
end