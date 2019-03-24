//
//  Deck.swift
//  War
//
//  Created by Daniel Baird on 3/23/19.
//  Copyright © 2019 Daniel Baird. All rights reserved.
//

import Foundation

class Deck {
    
    private var cards = [Card]()
    
    // Returns a full standard deck
    static func fullDeck() -> Deck {
        let deck = Deck()
        deck.cards = Deck.fullSuit(.Heart) +
            Deck.fullSuit(.Club) +
            Deck.fullSuit(.Diamond) +
            Deck.fullSuit(.Spade)
        return deck
    }
    
    // Default empty deck
    init() {}
    
    // Init to start with a specific non-default deck
    init(_ cards: [Card]) {
        self.cards = cards
    }
    
    public func shuffle() {
        cards.shuffle()
    }
    
    public func drawFromTop() -> Card? {
        return cards.removeFirst()
    }
    
    public func drawFromTop(_ num: Int) -> [Card] {
        var topCards = [Card]()
        for _ in 0..<num {
            if (cards.count == 0) { break }
            topCards.append(cards.removeFirst())
        }
        
        return topCards
    }
    
    public func drawRandom() -> Card? {
        let randomNumber = Int(arc4random_uniform(UInt32(count())))
        return cards.remove(at: randomNumber)
    }
    
    public func drawFromBottom() -> Card? {
        return cards.removeLast()
    }
    
    public func drawFromBottom(_ num: Int) -> [Card] {
        var bottomCards = [Card]()
        for _ in 0..<num {
            if (cards.count == 0) { break }
            bottomCards.append(cards.removeLast())
        }
        
        return bottomCards
    }
    
    public func addToBottom(_ card: Card) {
        cards.append(card)
    }
    
    public func addToBottom(_ newCards: [Card]) {
        cards.append(contentsOf: newCards)
    }
    
    public func addToTop(_ card: Card) {
        cards.insert(card, at: 0)
    }
    
    public func addToTop(_ newCards: [Card]) {
        cards.insert(contentsOf: newCards, at: 0)
    }
    
    public func count() -> Int {
        return cards.count
    }
    
    // Helper method to build a suit of cards
    private static func fullSuit(_ suit: Suit) -> [Card] {
        return [
            .Ace(suit),
            .King(suit),
            .Queen(suit),
            .Jack(suit),
            .Ten(suit),
            .Nine(suit),
            .Eight(suit),
            .Seven(suit),
            .Six(suit),
            .Five(suit),
            .Four(suit),
            .Three(suit),
            .Two(suit)
        ]
    }
    
    public func printDeck() {
        for card in cards {
            print("\(card))")
        }
    }
}
