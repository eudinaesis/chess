class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class HumanPlayer < Player
  def play_turn
    input = nil
    begin
      puts "#{self.color.to_s.capitalize} player: where would you like to move? format: a7 a6"
      input = gets.chomp.downcase.match(/\A([a-h][1-8])\s([a-h][1-8])\z/)
    end while input.nil?

    HumanPlayer::map_format(input[1..2])
  end

  def self.map_format(input_array)
    col_hash = {
      "a" => 0,
      "b" => 1,
      "c" => 2,
      "d" => 3,
      "e" => 4,
      "f" => 5,
      "g" => 6,
      "h" => 7
    }

    old_and_new = input_array.map do |pos|
      [8-pos[1].to_i, col_hash[pos[0]]]
    end
    return old_and_new[0], old_and_new[1]
  end
end