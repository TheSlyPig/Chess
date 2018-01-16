require 'byebug'
require_relative 'pieces'

class ChessError < StandardError; end
class PieceNotFoundError < ChessError; end
class InvalidMoveError < ChessError; end

class Board

  def make_special_row(color)
    top_bot = color == :black ? 0 : 7
    [
      Rook.new(self, [top_bot, 0], color),
      Knight.new(self, [top_bot, 1], color),
      Bishop.new(self, [top_bot, 2], color),
      Queen.new(self, [top_bot, 3], color),
      King.new(self, [top_bot, 4], color),
      Bishop.new(self, [top_bot, 5], color),
      Knight.new(self, [top_bot, 6], color),
      Rook.new(self, [top_bot, 7], color)
    ]
  end


  def make_pawn_row(color)
    top_bot = color == :black ? 1 : 6
    [
      Pawn.new(self, [top_bot, 0], color),
      Pawn.new(self, [top_bot, 1], color),
      Pawn.new(self, [top_bot, 2], color),
      Pawn.new(self, [top_bot, 3], color),
      Pawn.new(self, [top_bot, 4], color),
      Pawn.new(self, [top_bot, 5], color),
      Pawn.new(self, [top_bot, 6], color),
      Pawn.new(self, [top_bot, 7], color)
    ]
  end

  def initialize

    nil_row = Array.new(8) { NullPiece.instance }

    @grid = [
      self.make_special_row(:black),
      self.make_pawn_row(:black),
      nil_row.dup,
      nil_row.dup,
      nil_row.dup,
      nil_row.dup,
      self.make_pawn_row(:white),
      self.make_special_row(:white)
    ]
  end

  def move_piece(start_pos, end_pos)
    piece_to_move = self[start_pos]
    if piece_to_move.is_a?(NullPiece)
      raise PieceNotFoundError
    elsif !piece_to_move.valid_moves.include?(end_pos)
      raise InvalidMoveError
    end
    piece_to_move.pos = end_pos
    self[end_pos] = piece_to_move
    self[start_pos] = NullPiece.instance

    piece_to_move.has_moved if piece_to_move.is_a?(Pawn)

  end

  def force_move_piece(start_pos, end_pos)
    piece_to_move = self[start_pos]
    piece_to_move.pos = end_pos
    self[end_pos] = piece_to_move
    self[start_pos] = NullPiece.instance
  end


  def deep_dup
    board_dup = Board.new

    dup_grid = @grid.map do |row|
      row.map do |piece|
        piece.dup_with_new_board(board_dup)
      end
    end

    board_dup.grid = dup_grid
    board_dup
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
    king_pos = find_king(color)
    enemy_moves = get_enemy_moves(color)
    enemy_moves.include?(king_pos)
  end

  def checkmate?(color)
    return false unless in_check?(color)
    moves = []

    @grid.each do |row|
      row.each do |piece|
        if piece.color == color
         moves.concat(piece.valid_moves)
        end
      end
    end

    moves.empty?
  end

  private

  def find_king(color)
    kings = []
    @grid.each do |row|
      row.each do |piece|
        kings << piece if piece.is_a?(King)
      end
    end

    return kings.select { |king| king.color == color }.first.pos
  end

  def get_enemy_moves(color)
    enemy_moves = []
    @grid.each do |row|
      row.each do |piece|
        if piece.color != color
          enemy_moves.concat(piece.moves)
        end
      end
    end
    return enemy_moves
  end


  protected
  attr_writer :grid
end
