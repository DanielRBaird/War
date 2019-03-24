//
//  main.swift
//  War
//
//  Created by Daniel Baird on 3/23/19.
//  Copyright © 2019 Daniel Baird. All rights reserved.
//

import Foundation

print("War!")

var war = War(verbose: false, randomizeBottomPlacement: true)
war.play(games: 1_000_000)

var player1WinCount = 0
var player2WinCount = 0
var completedGameRounds = 0
var longestGame = 0
var shortestGame = Int.max

// Generate our stats.
for gameStats in war.gameStats {
    if gameStats.win != 0 {
        completedGameRounds += gameStats.rounds
        if gameStats.rounds > longestGame { longestGame = gameStats.rounds }
        if gameStats.rounds < shortestGame { shortestGame = gameStats.rounds }
    }
    if gameStats.win == 1 { player1WinCount += 1 }
    if gameStats.win == 2 { player2WinCount += 1 }
    
    //print(gameStats)
}

var gamesExitedForBeingTooLong = war.gameStats.count - (player1WinCount + player2WinCount)
var averageNumberOfTurns = completedGameRounds / (player1WinCount + player2WinCount)
print("Player 1 won \(player1WinCount) games")
print("Player 2 won \(player2WinCount) games")
print("\(gamesExitedForBeingTooLong) games where exited because they took too long.")
print("The averge number of turns to complete a round (not counting incomplete rounds) is: \(averageNumberOfTurns)")
print("The longest game was \(longestGame) rounds.")
print("The shortest game was \(shortestGame) rounds")
//war.createCSVAveragedRoundCount(war.gameStats.map({ $0.rounds }), dataPoints: 20)
//war.createCSV(war.gameStats)
