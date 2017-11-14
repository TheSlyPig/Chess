load 'Piece.rb'
load 'Board.rb'
load 'Display.rb'
load 'cursor.rb'
load 'game.rb'
load 'HumanPlayer.rb'

b = Board.new
g = Game.new(b)
g.run