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
