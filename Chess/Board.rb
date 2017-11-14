require 'byebug'

class ChessError < StandardError; end
class PieceNotFoundError < ChessError; end
class InvalidMoveError < ChessError; end

class Board
  # attr_reader :grid
  
  def make_special_row(color)
    top_bot = color == :white ? 0 : 7
    [
      Rook.new(:R, self, [top_bot, 0], color), 
      Knight.new(:H, self, [top_bot, 1], color), 
      Bishop.new(:B, self, [top_bot, 2], color), 
      Queen.new(:Q, self, [top_bot, 3], color), 
      King.new(:K, self, [top_bot, 4], color), 
      Bishop.new(:B, self, [top_bot, 5], color), 
      Knight.new(:H, self, [top_bot, 6], color), 
      Rook.new(:R, self, [top_bot, 7], color)
    ]
  end

  
  def make_pawn_row(color)
    top_bot = color == :white ? 1 : 6
    [
      Pawn.new(:P, self, [top_bot, 0], color), 
      Pawn.new(:P, self, [top_bot, 1], color), 
      Pawn.new(:P, self, [top_bot, 2], color), 
      Pawn.new(:P, self, [top_bot, 3], color), 
      Pawn.new(:P, self, [top_bot, 4], color), 
      Pawn.new(:P, self, [top_bot, 5], color), 
      Pawn.new(:P, self, [top_bot, 6], color), 
      Pawn.new(:P, self, [top_bot, 7], color)
    ]
  end
  
  def initialize
    
    # pawns = Array.new(8) { Piece.new(:P) }
    nil_row = Array.new(8) { NullPiece.instance }
    
    @grid = [
      self.make_special_row(:white),
      self.make_pawn_row(:white),
      nil_row.dup,
      nil_row.dup,
      nil_row.dup,
      nil_row.dup,
      self.make_pawn_row(:black),
      self.make_special_row(:black)
    ]
  end
  
  def move_piece(start_pos, end_pos)
    
    if self[start_pos].is_a?(NullPiece)
      raise PieceNotFoundError
    elsif !self.valid_move?(start_pos, end_pos)
      raise InvalidMoveError
    end
    
    piece = self[start_pos]
    piece.pos = end_pos
    self[end_pos] = piece
    self[start_pos] = NullPiece.instance
    
  end
  
  def valid_move?(start_pos, end_pos)
    #raise "Not Implemented"
    true
  end
  
  def [](pos)
    x, y = pos
    @grid[x][y]
  end
  
  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end
  
  def self.in_bounds?(pos)
    x, y = pos
    x.between?(0, 7) && y.between?(0, 7)
  end
  
  def in_check?(color)
    kings = []
    @grid.each do |row|
      row.each do |piece|
        kings << piece if piece.is_a?(King)
      end
    end
    
    king_pos = kings.select { |king| king.color == color }.first.pos
    
    enemy_moves = []
    @grid.each do |row|
      row.each do |piece|
        if piece.color != color
          enemy_moves.concat(piece.moves)
        end
      end
    end
    
    enemy_moves.include?(king_pos)    
  end
  
  #for debugging only
  def put_piece(piece)
    self[piece.pos] = piece
  end
  
end