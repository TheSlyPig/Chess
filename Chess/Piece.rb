require 'singleton'
require 'byebug'

class Piece
  attr_reader :type, :pos, :color, :symbol
  def initialize(type, board, pos, color = nil)
    @type = type
    @board = board
    @pos = pos
    @color = color
  end
  
  def self.increment_pos(pos, incr)
    x, y = pos
    dx, dy = incr
    [x + dx, y + dy]
  end
  
  def self.friendly?(other_piece)
    self.color == other_piece.color
  end
  
  def to_s
    self.type.to_s + " "
  end
  
end

module SlidingPiece
  DIAG_INCREMENTS = [[-1, -1], [1, 1], [-1, 1], [1, -1]]
  HORIZ_INCREMENTS = [[0, 1], [0, -1]]
  VERT_INCREMENTS = [[1, 0], [-1, 0]]

  def moves
    possible_moves = []
    
    increments = []
    increments.concat(DIAG_INCREMENTS) if self.move_dirs.include?(:diagonal)
    increments.concat(HORIZ_INCREMENTS) if self.move_dirs.include?(:horizontal)
    increments.concat(VERT_INCREMENTS) if self.move_dirs.include?(:vertical)

    increments.each do |incr|
      prev_pos = self.pos
      loop do
        new_pos = self.class.increment_pos(prev_pos, incr)
        break unless Board.in_bounds?(new_pos)
        
        piece_in_way = @board[new_pos]
        #enemy piece
        if !self.friendly?(piece_in_way) && !piece_in_way.is_a?(NullPiece)
          possible_moves << new_pos
          break
        elsif self.friendly?(piece_in_way) && !piece_in_way.is_a?(NullPiece)
          break
        end  
        possible_moves << new_pos
        prev_pos = new_pos
      end
    end
    
    possible_moves
  end
  
end

module SteppingPiece
  def moves
    debugger
    possible_moves = []
    
    steps = self.get_steps
    
    steps.each do |step|
      start_x, start_y = self.pos
      dx, dy = step
      new_pos = [start_x + dx, start_y + dy]
      possible_moves << new_pos
    end
    
    
    possible_moves.select do |move|
      Board.in_bounds?(move) && @board[move].color != self.color
    end
  end
end

class NullPiece < Piece
  include Singleton
  
  def initialize
    @color = nil
    @symbol = nil
  end
  
  def to_s
    "- "
  end
  
end

class Bishop < Piece
  include SlidingPiece
  
  def move_dirs
    [:diagonal]
  end
  
end

class Rook < Piece
  include SlidingPiece
  
  def move_dirs
    [:horizontal, :vertical]
  end
  
end

class Queen < Piece
  include SlidingPiece
  
  def move_dirs
    [:diagonal, :horizontal, :vertical]
  end

end

class King < Piece
  include SteppingPiece
  def get_steps
    [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1]
    ]   
  end
  
end

class Knight < Piece
  include SteppingPiece
  def get_steps
    [
      [2, 1],
      [2, -1],
      [-2, 1],
      [-2, -1],
      [1, 2],
      [-1, 2],
      [1, -2],
      [-1, -2]
    ]
  end
end