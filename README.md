# Chess

Play chess against a friend or a computer opponent, or simply watch two AI players battle to the death. Built using Ruby.

![Chess Gameplay](/screenshots/ai-game.gif)

## How to play

The game is console-based, so in order to play you'll need to clone this repository, open up a terminal window, and navigate to the game's folder and type 'Ruby chess.rb'.

## AI implementation

The AI uses a point-value system to determine what move to make, based on the relative value of any pieces it can attack. It will also attempt to avoid unfavorable trades (the logic on that is a work-in-progress). Essentially it looks at all possible moves and filters them based on the highest point value of enemy pieces on the target space (empty spaces have a point value of 0). It also ignores any moves where the point value of the enemy piece is lower than the point value of the moving piece, if the moving piece will be in the movement range of any enemy piece on the next turn (essentially, avoiding bad trades). It also slightly incentivizes moves that put the other player into check, and it hugely incentivizes moves that put the other player into checkmate. If there are no moves left after all this filtering, it simply chooses a random valid move (or passes if there are no valid moves available).

## Advanced Features

* Pawns can move 2 spaces if they haven't moved yet ✓
* Show valid moves on piece selection ✓
* Pawn promotion ✓
* Castling ✓
* En passant ☓

![Chess Gameplay](/screenshots/chess.gif)
