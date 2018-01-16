require_relative 'piece'
require_relative 'stepable'

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
    self.color == :black ? 1 : -1
  end

  def to_s
    "♟".colorize(self.color)
  end

end
