class HumanPlayer
  
  def initialize(board, display, color, name)
    @board = board
    @cursor = display.cursor
    @stored_pos = nil
    @display = display
    @color = color
    @name = name
  end
  
  def play_turn
    loop do
      system("clear")
      @display.render
      selected_pos = @cursor.get_input
      next if selected_pos.nil?
      
      if @cursor.selected == false
        @board.move_piece(@stored_pos, selected_pos)
        @display.selected_pos = nil
        break
      else
        unless @board[selected_pos].color == @color
          @stored_pos = selected_pos
          @display.selected_pos = selected_pos
        else
          @cursor.selected = false
        end
      end
      
    end
  end
  
end