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

  # def display
  #   icon_hash = {[:King, :white] => "\u2654",
  #     [:Queen, :white] => "\u2655",
  #     [:Rook, :white] => "\u2656",
  #     [:Bishop, :white] => "\u2657",
  #     [:Knight, :white] => "\u2658",
  #     [:Pawn, :white] => "\u2659",
  #     [:King, :black] => "\u265A",
  #     [:Queen, :black] => "\u265B",
  #     [:Rook, :black] => "\u265C",
  #     [:Bishop, :black] => "\u265D",
  #     [:Knight, :black] => "\u265E",
  #     [:Pawn, :black] => "\u265F",
  #     [:blank] => " "
  #   }
  #   background_colors = { 0 => :white, 1 => :light_green }
  #   # icon_hash.each { |h| puts h.to_s.colorize( :color => :black, :background => :light_green ) }
  #   output = " abcdefgh \n"
  #   8.times do |row|
  #     output << "#{8 - row}"
  #     8.times do |col|
  #       # output << " ".colorize(:background => background_colors[(row + col) % 2]) # blank board!
  #       piece = @squares[row][col]
  #       if piece.nil?
  #         unicode_lookup = [:blank]
  #       else
  #         unicode_lookup = [piece.class.to_s.to_sym, piece.color]
  #       end
  #       output << "#{icon_hash[unicode_lookup]}".colorize(:color => :black, :background => background_colors[(row + col) % 2])
  #     end
  #     output << "#{8 - row}\n"
  #   end
  #   output << " abcdefgh\n\n"
  #   output
  # end

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
    output = " a b c d e f g h \n"
    8.times do |row|
      output << "#{8 - row}"
      8.times do |col|
        # output << " ".colorize(:background => background_colors[(row + col) % 2]) # blank board!
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
    # have move return true if legit, while changing board
    # return false if bad, change nothing

    if move_ok?(old_pos, new_pos, color)
      actual_move(old_pos, new_pos)
      return true
    end

    false
  end

  def move_ok?(old_pos, new_pos, color)
    !self[old_pos].nil? &&
    self[old_pos].color == color &&
    self[old_pos].is_legal?(old_pos, new_pos) &&
    !self.deep_dup.actual_move(old_pos, new_pos).check?(color)
  end

  def actual_move(old_pos, new_pos)
    self[old_pos], self[new_pos] = nil, self[old_pos]
    self
  end

  #check if color's king is in check
  def check?(color)
    #find color's king
    king_pos = king_pos(color)
    # generates array of opponent piece locations
    enemy_locations = locations(Board::flip(color))
    #is color's king's position included in any of opposite color's legal moves
    # for each location, get piece there, get legal moves

    enemy_locations.any? do |loc|
      enemy_piece = self[loc]
      enemy_piece.is_legal?(loc, king_pos)
    end
  end

  #check if color's king is in check mate
  def check_mate?(color)
    return false unless check?(color)

    friendly_locations = locations(color)

    friendly_locations.each do |loc|
      friendly_piece = self[loc]
      # puts "#{friendly_piece.class} : #{p friendly_piece.possible_moves(loc)}"
      friendly_piece.possible_moves(loc).each do |move|
        # puts "pawn looking at #{move}" if friendly_piece.class == Pawn
        test_board = deep_dup #done!
        test_board.actual_move(loc, move)
        return false unless test_board.check?(color)
        # is test in check?
      end
    end
    return true
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

