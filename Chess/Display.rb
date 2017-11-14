require_relative 'Board.rb'
require_relative 'cursor.rb'
require 'colorize'

class Display
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
  end
  
  def render
    image = ["  0 1 2 3 4 5 6 7"].colorize( :background => :light_black)
    (0..7).each do |i|
      row_image = "#{i} "
      (0..7).each do |j|
        pos = [i, j]
        piece_string = @board[pos].to_s
        piece = (piece_string + " ")
        if @cursor.cursor_pos == pos
          color = nil
          if @cursor.selected
            color = :red
          else
            color = :light_blue
          end
        end
        
        row_image << piece
      end
      image << row_image.colorize( :background => :light_black)
    end
    puts image.join("\n")
  end
  
  def cursor_render_test
    loop do
      system("clear")
      self.render
      @cursor.get_input
    end
  end
  
end