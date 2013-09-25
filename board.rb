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

  def initialize(mode = :new)
    @squares = Array.new(8) { Array.new(8) }

    initial_setup unless mode == :copy
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

  def move(old_pos, new_pos)
    moving_piece = @squares[old_pos[0]][old_pos[1]]
    if moving_piece.is_legal?(old_pos, new_pos)
      @squares[old_pos[0]][old_pos[1]], @squares[new_pos[0]][new_pos[1]] = nil, moving_piece
    else
      raise ArgumentError.new "Invalid move"
    end
  end

  #check if color's king is in check
  def check?(color)
    #find color's king
    king_pos = king_pos(color)
    # generates array of opponent piece locations
    enemy_locations = locations(flip(color))
    #is color's king's position included in any of opposite color's legal moves
    # for each location, get piece there, get legal moves

    enemy_locations.any? do |loc|
      enemy_piece = @squares[loc[0]][loc[1]]
      enemy_piece.is_legal?(loc, king_pos)
    end
  end

  #check if color's king is in check mate
  def check_mate?(color)
    return false unless check?(color)

    friendly_locations = locations(color)

    friendly_locations.each do |loc|
      friendly_piece = @squares[loc[0]][loc[1]]
      friendly_piece.possible_moves(loc).each do |move|
        test_board = deep_dup #done!
        test_board.move(loc, move)
        return false unless test_board.check?(color)
        # is test in check?
      end
    end
    return true
  end

  def flip(color)
    color == :white ? :black : :white
  end

  def king_pos(color)
    8.times do |row|
      8.times do |col|
        curr_square = @squares[row][col]
        if curr_square.is_a?(King) && curr_square.color == color
          return [row, col]
        end
      end
    end
  end

  def locations(color)
    locations = []

    8.times do |row|
      8.times do |col|
        curr_square = @squares[row][col]
        if curr_square != nil && curr_square.color == color
          locations << [row, col]
        end
      end
    end
    locations
  end

  def deep_dup
    dup_board = Board.new(:copy)

    [:white, :black].each do |color|
      duplicate_pieces(dup_board, locations(color), color)
    end

    dup_board
  end

  def duplicate_pieces(dup_board, locations, color)
    locations.each do |pos|
      y = pos[0]
      x = pos[1]
      dup_board.squares[y][x] = @squares[y][x].class.new(color, dup_board)
    end
    dup_board
  end

end

b = Board.new
puts b.display

b.move([1, 4], [2, 4])
puts b.display

b.move([0, 3], [4, 7])
puts b.display

b.move([4, 7], [6, 5])
puts b.display

puts "white should be in check now!"
puts "Is White in check? #{b.check?(:white)}"

puts "is White in checkmate? #{b.check_mate?(:white)}"