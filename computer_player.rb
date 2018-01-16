require_relative 'pieces'

class ComputerPlayer
  attr_reader :name

  def initialize(board, display, color, name)
    @board = board
    @display = display
    @color = color
    @name = name
  end

  def play_turn
    loop do
      handle_rendering
      @board.computer_move_piece
      break
    end
  end

  private

  def handle_rendering
    system("clear")
    @display.render
    puts "#{@name}'s turn! (#{@color.to_s})"
  end

end
