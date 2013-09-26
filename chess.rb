require "./board.rb"
require "./player.rb"

class Game
  attr_reader :chess_board

  def play(board = Board.new)
    @chess_board = board
    players = [HumanPlayer.new(:white), HumanPlayer.new(:black)]

    while true
      players.each do |player|
        new_pos = []
        puts @chess_board.display
        puts "#{player.color.to_s.capitalize} is in check!" if @chess_board.check?(player.color)
        begin
          curr_pos, new_pos = player.play_turn
        end until @chess_board.move(curr_pos, new_pos, player.color)

        if @chess_board.pawn_promote?
          puts @chess_board.display
          @chess_board.pawn_promote!(new_pos, promo_pieces(player.promotion_choice, player.color))
        end

        return end_of_game(player.color) if game_over?(player.color)
      end
    end
  end

  def promo_pieces(player_choice, color)
    promo_pieces = {
      "q" => Queen.new(color, @chess_board),
      "r" => Rook.new(color, @chess_board),
      "n" => Knight.new(color, @chess_board),
      "b" => Bishop.new(color, @chess_board)
    }
    return promo_pieces[player_choice]
  end

  def game_over?(color)
    @chess_board.checkmate?(Board::flip(color)) ||
    @chess_board.stalemate?(Board::flip(color))
    #add stalemate later
  end

  def end_of_game(color)
    puts @chess_board.display
    if @chess_board.check?(Board::flip(color))
      puts "#{color.to_s.capitalize} has won. Congratulations!"
    else
      puts "Stalemate!"
    end
  end
end

# Game.new.play

# b = Board.new
# puts b.display
#
# b.move([6,4],[5,4], :white)
# puts b.display
#
# b.move([1,5], [2,5], :black)
# puts b.display
#
# b.move([1,6],[3,6], :black)
# puts b.display
# #
# # b.move([2,6],[3,6])
# # puts b.display
# #
# b.move([7,3],[3,7], :white)
# puts b.display
# #
# #
# # puts "Is White in check? #{b.check?(:white)}"
# # puts "is White in checkmate? #{b.checkmate?(:white)}"
# #
# puts "Is black in check? #{b.check?(:black)}"
# puts "is black in checkmate? #{b.checkmate?(:black)}"

 Game.new.play(Board.test_pawn_promote)