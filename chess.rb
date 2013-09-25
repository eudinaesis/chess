require "./board.rb"
require "./player.rb"

class Game

  def play
    @chess_board = Board.new
    players = [HumanPlayer.new(:white), HumanPlayer.new(:black)]

    while true
      players.each do |player|
        puts @chess_board.display
        puts "#{player.color.to_s.capitalize} is in check!" if @chess_board.check?(player.color)
        begin
          curr_pos, new_pos = player.play_turn
        end until @chess_board.move(curr_pos, new_pos, player.color)
        return end_of_game(player.color) if game_over?(player.color)
      end
    end
  end

  def game_over?(color)
    @chess_board.check_mate?(Board::flip(color))
    #add stalemate later
  end

  def end_of_game(color)
    puts @chess_board.display
    puts "#{color} has won. Congratulations!"
  end
end

Game.new.play

b = Board.new
puts b.display

b.move([6,4],[5,4], :white)
puts b.display

b.move([1,5],[2,5], :black)
puts b.display

b.move([1,6],[2,6], :white)
puts b.display
#
# b.move([2,6],[3,6])
# puts b.display
#
b.move([7,3],[3,7], :white)
puts b.display
#
#
# puts "Is White in check? #{b.check?(:white)}"
# puts "is White in checkmate? #{b.check_mate?(:white)}"
#
puts "Is black in check? #{b.check?(:black)}"
puts "is black in checkmate? #{b.check_mate?(:black)}"