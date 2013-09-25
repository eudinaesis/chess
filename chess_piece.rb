# require "./bishop.rb"
# require "./knight.rb"
# require "./queen.rb"
# require "./king.rb"
# require "./pawn.rb"
# require "./rook.rb"

class ChessPiece
  attr_reader :color, :board
  def initialize(color, board)
    @color = color
    @board = board
  end
end