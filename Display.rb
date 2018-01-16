require_relative 'board.rb'
require_relative 'cursor.rb'
require 'colorize'

class Display
  attr_reader :cursor
  attr_writer :selected_pos
  attr_accessor :stored_moves

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board, self)
    @selected_pos = nil
    @stored_moves = nil
  end

  def get_square_color(pos, i, j)
    if i % 2 == 0
      if j % 2 != 0
        square_color = :light_black
      end
    elsif j % 2 == 0
      square_color = :light_black
    end

    if @cursor.selected && @stored_moves.nil?
      @stored_moves = @board[@selected_pos].valid_moves
    end

    unless @stored_moves.nil?
      square_color = :green if @stored_moves.include?(pos)
    end

    if @cursor.cursor_pos == pos
      if @cursor.selected
        square_color = :red
      else
        square_color = :light_blue
      end
    end
    return square_color
  end

  def render
    image = []
    (0..7).each do |i|
      row_image = ""
      (0..7).each do |j|
        pos = [i, j]
        piece_string = @board[pos].to_s

        square_color = get_square_color(pos, i, j)
        row_image << " ".colorize( :background => square_color) + piece_string.colorize( :background => square_color) + " ".colorize( :background => square_color)
      end
      image << row_image
    end
    puts image.join("\n")
  end

end
