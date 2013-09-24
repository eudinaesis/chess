require "./chess_piece.rb"
require "./sliding_piece.rb"
require "./stepping_piece.rb"
require "./rook.rb"
require "./bishop.rb"
require "./knight.rb"
require "./queen.rb"
require "./king.rb"
require "./pawn.rb"



require 'colorize'

class Board
  attr_reader :squares

  def initialize()
    @squares = Array.new(8) { Array.new(8) }

    initial_setup
  end

  def initial_setup
    # top row
    @squares[0][0] = Rook.new(:black, self)
    @squares[0][1] = Knight.new(:black, self)
    @squares[0][2] = Bishop.new(:black, self)
    @squares[0][3] = Queen.new(:black, self)
    @squares[0][4] = King.new(:black, self)
    @squares[0][5] = Bishop.new(:black, self)
    @squares[0][6] = Knight.new(:black, self)
    @squares[0][7] = Rook.new(:black, self)
    # 2nd row
    8.times { |col| @squares[1][col] = Pawn.new(:black, self) }

    # white pawns
    8.times { |col| @squares[6][col] = Pawn.new(:white, self) }
    # bottom row
    @squares[7][0] = Rook.new(:white, self)
    @squares[7][1] = Knight.new(:white, self)
    @squares[7][2] = Bishop.new(:white, self)
    @squares[7][3] = Queen.new(:white, self)
    @squares[7][4] = King.new(:white, self)
    @squares[7][5] = Bishop.new(:white, self)
    @squares[7][6] = Knight.new(:white, self)
    @squares[7][7] = Rook.new(:white, self)
  end

  def display
    icon_hash = {[:King, :white] => "\u2654",
      [:Queen, :white] => "\u2655",
      [:Rook, :white] => "\u2656",
      [:Bishop, :white] => "\u2657",
      [:Knight, :white] => "\u2658",
      [:Pawn, :white] => "\u2659",
      [:King, :black] => "\u265A",
      [:Queen, :black] => "\u265B",
      [:Rook, :black] => "\u265C",
      [:Bishop, :black] => "\u265D",
      [:Knight, :black] => "\u265E",
      [:Pawn, :black] => "\u265F",
      [:blank] => " "
    }
    background_colors = { 0 => :white, 1 => :light_green }
    # icon_hash.each { |h| puts h.to_s.colorize( :color => :black, :background => :light_green ) }
    output = ""
    8.times do |row|
      8.times do |col|
        # output << " ".colorize(:background => background_colors[(row + col) % 2]) # blank board!
        piece = @squares[row][col]
        if piece.nil?
          unicode_lookup = [:blank]
        else
          unicode_lookup = [piece.class.to_s.to_sym, piece.color]
        end
        output << "#{icon_hash[unicode_lookup]}".colorize(:color => :black, :background => background_colors[(row + col) % 2])
      end
      output << "\n"
    end
    output << "\n"
    output
  end

  #does not check for legality of move
  def move(old_pos, new_pos)
    moving_piece = @squares[old_pos[0]][old_pos[1]]
    if moving_piece.is_legal?(old_pos, new_pos)
      @squares[old_pos[0]][old_pos[1]], @squares[new_pos[0]][new_pos[1]] = nil, moving_piece
    else
      raise ArgumentError.new "Invalid move"
    end
  end
end

b = Board.new
puts b.display

b.move([0, 4], [1, 4])
puts b.display
b.move([1, 4], [2, 3])
puts b.display
b.move([2, 3], [4, 5])
puts b.display