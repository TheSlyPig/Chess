require 'singleton'
require 'byebug'

class Piece
  attr_reader :color, :symbol
  attr_accessor :pos
  def initialize(board, pos, color = nil)
    @board = board
    @pos = pos
    @color = color
  end
  
  def self.increment_pos(pos, incr)
    x, y = pos
    dx, dy = incr
    [x + dx, y + dy]
  end
  
  def friendly?(other_piece)
    self.color == other_piece.color
  end
  
  def move_into_check?(end_pos)
    # debugger
    board_dup = @board.deep_dup
    board_dup.force_move_piece(self.pos, end_pos)
    board_dup.in_check?(self.color)
  end
  
  def valid_moves
    self.moves.reject { |pos| move_into_check?(pos) }
  end
  
  def dup_with_new_board(duped_board)
    self.class.new(duped_board, self.pos, self.color)
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
    possible_moves = []
    
    steps = self.get_steps
    
    steps.each do |step|
      start_x, start_y = self.pos
      dx, dy = step
      new_pos = [start_x + dx, start_y + dy]
      possible_moves << new_pos
    end
    
    
    possible_moves.select do |move|
      Board.in_bounds?(move) && !self.friendly?(@board[move])
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
    "-"
  end
  
  def moves
    []
  end
  
  def dup_with_new_board(duped_board)
    NullPiece.instance
  end
  
end

class Bishop < Piece
  include SlidingPiece
  
  def move_dirs
    [:diagonal]
  end
  
  def to_s
    "♝".colorize(self.color)
  end
  
end

class Rook < Piece
  include SlidingPiece
  
  def move_dirs
    [:horizontal, :vertical]
  end
  
  def to_s
    "♜".colorize(self.color)
  end
  
end

class Queen < Piece
  include SlidingPiece
  
  def move_dirs
    [:diagonal, :horizontal, :vertical]
  end
  
  def to_s
    "♛".colorize(self.color)
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
  
  def to_s
    "♚".colorize(self.color)
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
  
  def to_s
    "♞".colorize(self.color)
  end
  
end

class Pawn < Piece
  
  def initialize(board, pos, color = nil)
    @has_moved = false
    super
  end
  
  def has_moved
    @has_moved = true
  end
  
  def moves
    possible_moves = []
    
    possible_moves += check_forward_moves
    possible_moves += check_attack_moves
    
    possible_moves
  end
  
  def check_forward_moves
    x, y = self.pos
    up_down = self.up_or_down
    
    possible_forward_moves = []
    one_forward = [x + up_down, y]
    two_forward = [x + (2 * up_down), y]
    
    #case for moving one space
    first_piece = @board[one_forward]
    if first_piece.is_a?(NullPiece) && Board.in_bounds?(one_forward)
      possible_forward_moves << one_forward 
    end
    
    #case for moving two spaces
    second_piece = @board[two_forward]
    if second_piece.is_a?(NullPiece) && Board.in_bounds?(two_forward) && first_piece.is_a?(NullPiece)
      possible_forward_moves << two_forward unless @has_moved == true
    end
    
    possible_forward_moves
  end
  
  def check_attack_moves
    x, y = self.pos
    up_down = self.up_or_down
    
    possible_attack_moves = []
    left_pos = [x + up_down, y - 1]
    right_pos = [x + up_down, y + 1]
    
    
    [left_pos, right_pos].each do |pos|
      other_piece = @board[pos]
      unless !Board.in_bounds?(pos) || other_piece.is_a?(NullPiece) || self.friendly?(other_piece)
        possible_attack_moves << pos
      end
    end
    
    possible_attack_moves
  end
  
  def up_or_down
    self.color == :white ? 1 : -1
  end
  
  def to_s
    "♟".colorize(self.color)
  end
  
  
end