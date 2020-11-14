//
//  War.swift
//  War
//
//  Created by Daniel Baird on 3/23/19.
//  Copyright © 2019 Daniel Baird. All rights reserved.
//

import Foundation

class War {
    // This indicates if we are going to put the cards on the bottom of the users
    // stack in a predictable order or not.
    var randomizeBottomPlacement: Bool
    
    var noWinAtNum = 100_000
    var gameStats = [(win:Int, rounds:Int)]()
    
    // Ill assign this a number when someone wins.
    var win: Int? = nil
    var wars = 0
    var rounds = 0
    var verbose: Bool
    
    var playerOneHand: Deck!
    var playerTwoHand: Deck!
    
    init(verbose: Bool = false, randomizeBottomPlacement: Bool = true) {
        self.randomizeBottomPlacement = randomizeBottomPlacement
        self.verbose = verbose
        deal()
    }
    
    public func reset() {
        win = nil
        rounds = 0
        wars = 0
        deal()
    }
    
    // This is the game loop that won't exit until the game is over.
    public func play(games: Int = 1) {
        var lastPrintedRounds = 0;
        
        for _ in 1...games {
            while win == nil {
                playRound()
                if verbose {
                    if rounds >= lastPrintedRounds * 2 {
                        lastPrintedRounds = rounds
                        print("Current rounds: \(rounds). Cards per hand: \(playerOneHand.count()), \(playerTwoHand.count())")
                    }
                }
                
                if rounds == noWinAtNum {
                    if verbose {
                        print("Game force ended at \(noWinAtNum) rounds.")
                    }
                    win = 0
                }
            }
            
            lastPrintedRounds = 0;
            gameStats.append((win: win!, rounds: rounds))
            reset()
        }
    }
    
    private func deal() {
        win = nil
        let deck = Deck.fullDeck()
        deck.shuffle()
        playerOneHand = Deck()
        playerTwoHand = Deck()
        
        // Deal the players their cards.
        var playerFlag = true
        while deck.count() > 0 {
            let card = deck.drawFromTop()
            (playerFlag ? playerOneHand : playerTwoHand).addToTop(card!)
            playerFlag.toggle()
        }
        
        if (verbose) {
            print("****** CARDS DEALT ******");
            print("*************************")
            print("Player 1 hand: ")
            playerOneHand.printDeck()
            print("*************************")
            print("*************************")
            print("Player 2 hand: ")
            playerTwoHand.printDeck()
        }
        
    }
    
    private func playRound() {
        rounds += 1
        drawTopAndCompare()
        
        if playerOneHand.count() == 0 { win = 2 }
        if playerTwoHand.count() == 0 { win = 1 }
    }
    
    private func drawTopAndCompare(lootPile: [Card]? = nil) {
        var lootPileMutable = lootPile ?? [Card]()
        // Draw a card from the top of each players deck
        let playerOneCard = playerOneHand.drawFromTop()!
        let playerTwoCard = playerTwoHand.drawFromTop()!
        
        lootPileMutable.append(playerOneCard)
        lootPileMutable.append(playerTwoCard)
    
        // There are 3 possibilities.
        // 1. Player one takes it.
        // 2. Player two takes it.
        // 3. War
        let comparisonResult = compare(playerOneCard, playerTwoCard)
        
        if verbose {
            var symbol = "="
            if comparisonResult == 1 { symbol = ">" }
            if comparisonResult == -1 { symbol = "<" }
            
            print("\(playerOneCard) " + symbol + " \(playerTwoCard)")
        }
        
        if comparisonResult != 0 {
            
            if randomizeBottomPlacement { lootPileMutable.shuffle() }
            
            (comparisonResult > 0 ? playerOneHand : playerTwoHand)?.addToBottom(lootPileMutable)
        } else {
            // WAR!
            resolveWar(lootPile: lootPileMutable)
        }
    }
    
    private func resolveWar(lootPile: [Card]) {
        wars += 1
        
        var lootPileMutable = lootPile
        // Check to make sure we aren't going to run out of cards in the middle of the war.
        if playerOneHand.count() < 2 {
            win = 2
            return
        } else if (playerTwoHand.count() < 2) {
            win = 1
            return
        }
        
        // Each player flips one card over that is not used to determine the win.
        lootPileMutable.append(playerOneHand.drawFromTop()!)
        lootPileMutable.append(playerTwoHand.drawFromTop()!)
        
        // Because we are drawing a card, we are going to count this as an extra round.
        rounds += 1;
        
        // The next card is essentially a normal play, just taking the loot pile along.
        drawTopAndCompare(lootPile: lootPileMutable)
    }
    
    private func compare(_ card1: Card, _ card2: Card) -> Int {
        let c1Val = cardValue(card1)
        let c2Val = cardValue(card2)
        
        if (c1Val > c2Val) { return 1 }
        if (c1Val < c2Val) { return -1 }
        return 0
    }
    
    private func cardValue(_ card: Card) -> Int {
        switch card {
            case .Ace(_):
                return 14
            case .King(_):
                return 13
            case .Queen(_):
                return 12
            case .Jack(_):
                return 11
            case .Ten(_):
                return 10
            case .Nine(_):
                return 9
            case .Eight(_):
                return 8
            case .Seven(_):
                return 7
            case .Six(_):
                return 6
            case .Five(_):
                return 5
            case .Four(_):
                return 4
            case .Three(_):
                return 3
            case .Two(_):
                return 2
        }
    }
    
    func createCSVAveragedRoundCount(_ roundsArray:[Int], dataPoints: Int = 1) -> Void {
        if dataPoints < 1 || dataPoints > roundsArray.count { return }
        
        var mutableRoundsArray = roundsArray
        let bucketSize = mutableRoundsArray.count / dataPoints
        
        // Sort so that we average sorted data.
        mutableRoundsArray.sort()

        var bucketedRounds = [Int]()
        var bucketTotal = 0
        var bucketCount = 0
        for rounds in mutableRoundsArray {
            bucketCount += 1
            bucketTotal += rounds
            
            if bucketCount == bucketSize {
                // The bucket is full. Average, and empty.
                bucketedRounds.append(bucketTotal / bucketSize)
                bucketCount = 0
                bucketTotal = 0
            }
        }
        
        // Now bucketedRounds contains our data.
        let fileName = "rounds.csv"
        let path = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(fileName)
        var csvText = "round\n"
        
        for rounds in bucketedRounds {
            let newLine = "\(rounds)\n"
            csvText.append(newLine)
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
        if path != nil {
            print("Saved stats at path: \(path!)")
        }
    }
    
    func createCSV(_ stats:[(win:Int, rounds:Int)]) -> Void {
        
        let fileName = "stats.csv"
        let path = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(fileName)
        var csvText = "win,round\n"
        
        for stat in stats {
            let newLine = "\(stat.win),\(stat.rounds)\n"
            csvText.append(newLine)
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
        if path != nil {
            print("Saved stats at path: \(path!)")
        }
    }

}
