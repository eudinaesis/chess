require "./board.rb"
require "./player.rb"

class Game

  def play
    @chess_board = Board.new
    players = [HumanPlayer.new(:white), HumanPlayer.new(:black)]

    while true
      players.each do |player|
        puts @chess_board.display
        begin
          curr_pos, new_pos = player.play_turn
        end until !@chess_board.squares[curr_pos[0]][curr_pos[1]].nil? &&
        @chess_board.squares[curr_pos[0]][curr_pos[1]].color == player.color &&
        @chess_board.squares[curr_pos[0]][curr_pos[1]].is_legal?(curr_pos, new_pos) &&


        @chess_board.move(curr_pos, new_pos)
        return player.color if game_over?(player.color)
      end
    end
  end

  def game_over?(color)
    @chess_board.check_mate?(Board::flip(color))
    #add stalemate later
  end

  def end_of_game(color)
    puts "#{color} has won. Congratulations!"
  end
end

Game.new.play

# b = Board.new
# puts b.display
#
# b.move([6,4],[5,4])
# puts b.display
#
# b.move([1,5],[2,5])
# puts b.display
#
# b.move([1,6],[2,6])
# puts b.display
#
# b.move([2,6],[3,6])
# puts b.display
#
# b.move([7,3],[3,7])
# puts b.display
#
#
# puts "Is White in check? #{b.check?(:white)}"
# puts "is White in checkmate? #{b.check_mate?(:white)}"
#
# puts "Is black in check? #{b.check?(:black)}"
# puts "is black in checkmate? #{b.check_mate?(:black)}"