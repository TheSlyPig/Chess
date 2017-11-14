require_relative 'Display.rb'
require_relative 'HumanPlayer.rb'
class Game
  
  def initialize(board)
    @board = board
    @display = Display.new(@board)
    @player1 = HumanPlayer.new(board, @display, :white, "Player 1")
    @player2 = HumanPlayer.new(board, @display, :black, "Player 2")
    @currentplayer = @player1
  end
  
  def run
    until over?
      take_turn
      switch_players!
    end
    
    winner
  end
  
  def take_turn
    @currentplayer.play_turn
  rescue InvalidMoveError
    retry
  end
  
  def switch_players!
    @currentplayer = (@currentplayer == @player1 ? @player2 : @player1)
    nil
  end
  
  def over?
    @board.checkmate?(:white) || @board.checkmate?(:black)
  end
  
  def winner
    switch_players!
    system("clear")
    @display.render
    puts "#{@currentplayer.name} has won!"
  end
  
end