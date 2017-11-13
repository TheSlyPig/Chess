require_relative 'Piece.rb'
require 'byebug'

class ChessError < StandardError; end
class PieceNotFoundError < ChessError; end
class InvalidMoveError < ChessError; end

class Board
  # attr_reader :grid
  
  def self.make_special_row(color)
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

  
  def self.make_pawn_row(color)
    top_bot = color == :white ? 1 : 6
    [
      Piece.new(:P, self, [top_bot, 0], color), 
      Piece.new(:P, self, [top_bot, 1], color), 
      Piece.new(:P, self, [top_bot, 2], color), 
      Piece.new(:P, self, [top_bot, 3], color), 
      Piece.new(:P, self, [top_bot, 4], color), 
      Piece.new(:P, self, [top_bot, 5], color), 
      Piece.new(:P, self, [top_bot, 6], color), 
      Piece.new(:P, self, [top_bot, 7], color)
    ]
  end
  
  def initialize
    
    # pawns = Array.new(8) { Piece.new(:P) }
    nil_row = Array.new(8) { NullPiece.instance }
    
    @grid = [
      self.class.make_special_row(:white),
      self.class.make_pawn_row(:white),
      nil_row.dup,
      nil_row.dup,
      nil_row.dup,
      nil_row.dup,
      self.class.make_pawn_row(:black),
      self.class.make_special_row(:black)
    ]
  end
  
  def move_piece(start_pos, end_pos)
    
    if self[start_pos].nil?
      raise PieceNotFoundError
    elsif !self.valid_move?(start_pos, end_pos)
      raise InvalidMoveError
    end
    
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
    
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
end