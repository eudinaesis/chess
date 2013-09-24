# require "./chess_piece.rb"
include SteppingPiece

class Knight < ChessPiece
  attr_reader :deltas

  def initialize(color, board)
    super(color, board)
    @deltas = [

    ]
  end
end