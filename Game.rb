require_relative 'display.rb'
require_relative 'human_player.rb'
require_relative 'computer_player.rb'
class Game

  def initialize(board)
    @board = board
    @display = Display.new(@board)
    @player1 = HumanPlayer.new(board, @display, :white, "Player 1")
    @player2 = HumanPlayer.new(board, @display, :black, "Player 2")
    @currentplayer = @player1
  end

  def setup
    reply = ""
    until reply == "1" || reply == "2"
      system("clear")
      puts "How many players? (1/2)"
      reply = gets.chomp
    end

    if reply == "1"
      @player2 = ComputerPlayer.new(@board, @display, :black, "Player 2")
    end
  end

  def run
    setup

    until over?
      take_turn
      switch_players!
    end

    winner
  end

  private

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
