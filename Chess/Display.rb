require_relative 'Board.rb'
require_relative 'cursor.rb'
require 'colorize'

class Display
  attr_reader :cursor
  attr_writer :selected_pos
  
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
    @selected_pos = nil
  end
  
  def render
    # image = ["  0 1 2 3 4 5 6 7 ".colorize( :background => :light_black)]
    image = []
    (0..7).each do |i|
      # row_image = "#{i} "
      row_image = ""
      (0..7).each do |j|
        pos = [i, j]
        piece_string = @board[pos].to_s
        cursor_color = :light_black

        possible_moves = @board[@selected_pos].valid_moves if @cursor.selected
        
        unless possible_moves.nil?
          cursor_color = :green if possible_moves.include?(pos)
        end
        
        if @cursor.cursor_pos == pos
          if @cursor.selected
            cursor_color = :red
          else
            cursor_color = :light_blue
          end
        end
        
        
        
        row_image << piece_string.colorize( :background => cursor_color) + " ".colorize( :background => :light_black)
      end
      image << row_image
    end
    print image.join("\n")
  end
  
end