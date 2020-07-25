# War
Just a simple war game that I made for fun.

I was playing a seemingly endless game of war with my 5 year old son one weekend, and thought it would be interesting to figure out how long these games usually take.
Obviously war doesn't actually require any human decisions, so I decided to just run a bunch of games and get some numbers out of it. 
Maybe not too interesting, but I did find that it matters quite a bit how cards are placed back into the hand of the winner. If the cards are consistently placed in the same order you often get games that will last forever, or at least long enough for a human to consider it endless.

Here is some sample data from a few times I ran the game:


### When Randomizing bottom placement
- 10,000 games
- Player 1 won 5081 games
- Player 2 won 4919 games
- 0 games where exited because they took too long
- The averge number of turns to complete a round (not counting incomplete rounds) is: 471
- The longest game was 5417 rounds
- The shortest game was 30 rounds

### When not randomizing bottom placement
- 1000 games (takes much longer to run these, so I didn't run as many)
- Player 1 won 311 games
- Player 2 won 274 games
- 415 games where exited because they took too long. (100,000 rounds)
- The averge number of turns to complete a round (not counting incomplete rounds) is: 1657
- The longest game was 12587 rounds
- The shortest game was 41 rounds
