//
//  main.swift
//  War
//
//  Created by Daniel Baird on 3/23/19.
//  Copyright © 2019 Daniel Baird. All rights reserved.
//

import Foundation

print("Hello, World!")

var war = War(verbose: false)
war.play(games: 1000)

var player1WinCount = 0
var player2WinCount = 0
for gameStats in war.gameStats {
    if gameStats.win == 1 { player1WinCount += 1 }
    if gameStats.win == 2 { player2WinCount += 1 }
    
    print(gameStats)
}


print("Player 1 won \(player1WinCount) games")
print("Player 2 won \(player2WinCount) games")
print("\(war.gameStats.count - (player1WinCount + player2WinCount)) games where exited because they took too long.")

