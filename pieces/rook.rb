require_relative 'piece'
require_relative 'slideable'

class Rook < Piece
  include SlidingPiece

  def move_dirs
    [:horizontal, :vertical]
  end

  def to_s
    "♜".colorize(self.color)
  end

end
