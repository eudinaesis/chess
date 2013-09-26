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

  def place_pieces(color)
    color == :black ? row = 0 : row = 7
    color == :black ? pawn_row = 1 : pawn_row = 6

    @squares[row][0] = Rook.new(color, self)
    @squares[row][1] = Knight.new(color, self)
    @squares[row][2] = Bishop.new(color, self)
    @squares[row][3] = Queen.new(color, self)
    @squares[row][4] = King.new(color, self)
    @squares[row][5] = Bishop.new(color, self)
    @squares[row][6] = Knight.new(color, self)
    @squares[row][7] = Rook.new(color, self)

    8.times { |col| @squares[pawn_row][col] = Pawn.new(color, self) }
  end

  def initial_setup
    place_pieces(:black)
    place_pieces(:white)
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

    output = " a b c d e f g h \n"
    8.times do |row|
      output << "#{8 - row}"
      8.times do |col|
        piece = @squares[row][col]
        if piece.nil?
          unicode_lookup = [:blank]
        else
          unicode_lookup = [piece.class.to_s.to_sym, piece.color]
        end
        output << "#{icon_hash[unicode_lookup]} ".colorize(:color => :black, :background => background_colors[(row + col) % 2])
      end
      output << "#{8 - row}\n"
    end
    output << " a b c d e f g h\n\n"
    output
  end

  def move(old_pos, new_pos, color)
    # returns true, and modifies board, if given valid move
    # otherwise returns false, changing nothing
    if move_ok?(old_pos, new_pos, color)
      move!(old_pos, new_pos)
      return true
    end

    false
  end

  def move_ok?(old_pos, new_pos, color)
    !self[old_pos].nil? &&
    self[old_pos].color == color &&
    self[old_pos].is_legal?(old_pos, new_pos) &&
    !self.deep_dup.move!(old_pos, new_pos).check?(color)
  end

  def move!(old_pos, new_pos)
    self[old_pos], self[new_pos] = nil, self[old_pos]
    self
  end

  def check?(color)
    king_pos = king_pos(color)
    enemy_locations = locations(Board::flip(color))

    enemy_locations.any? do |loc|
      enemy_piece = self[loc]
      enemy_piece.is_legal?(loc, king_pos)
    end
  end

  #check if color's king is in check mate
  def checkmate?(color)
    check?(color) && cannot_move_safely?(color)
  end

  def cannot_move_safely?(color)
    friendly_locations = locations(color)

    friendly_locations.each do |loc|
      friendly_piece = self[loc]
      # puts "#{friendly_piece.class} : #{p friendly_piece.possible_moves(loc)}"
      friendly_piece.possible_moves(loc).each do |move|
        # puts "pawn looking at #{move}" if friendly_piece.class == Pawn
        test_board = deep_dup #done!

        test_board.move!(loc, move)
        return false unless test_board.check?(color)
        # is test in check?
      end
    end
    return true
  end

  def stalemate?(color)
    #return false if check?(color)
    !check?(color) && cannot_move_safely?(color)
  end

  def self.flip(color)
    color == :white ? :black : :white
  end

  def [](pos)
    @squares[pos[0]][pos[1]]
  end

  def []=(pos, new_val)
    @squares[pos[0]][pos[1]] = new_val
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
    # returns locations of color's pieces
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

  def test_stalemate
    dup_board = Board.new(:copy)

    dup_board[[0, 7]] = King.new(:black, dup_board)
    dup_board[[1, 5]] = King.new(:white, dup_board)
    dup_board[[2, 6]] = Queen.new(:white, dup_board)

    puts dup_board.display
    puts "board is stalemate? #{dup_board.stalemate?(:black)}"
    puts "board is checkmate? #{dup_board.checkmate?(:black)}"
  end

  def duplicate_pieces(dup_board, locations, color)
    locations.each do |pos|
      dup_board[pos] = self[pos].class.new(color, dup_board)
    end
    dup_board
  end

  def self.off_board?(location)
    location.any? do |coord|
      coord < 0 || coord > 7
    end
  end

end

