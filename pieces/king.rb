require_relative 'piece'
require_relative 'stepable'

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
