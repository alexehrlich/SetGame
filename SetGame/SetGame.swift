//
//  SetGame.swift
//  SetGame
//
//  Created by Alexander Ehrlich on 09.09.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

struct SetGame {
    
    private (set) var cards = [Card]()
    private (set) var selectedCards = Set<Card>()
    private (set) var cardsInGame = [Card]()
    private (set) var successfulSetinGame = false
    private (set) var setsOnDeck = [Set<Card>]()
    
    
    var score = 0
    
    mutating func chooseCard(at index: Int) {
        
        //Das funktioniert hier nur, weil Card als Klasse gemacht wurde --> Reference type. Sonst würde bei chosenCard.isSelected = true auf einer Kope gearbeitet werden!
        let chosenCard = cardsInGame[index]
        
        //Für den Fall, dass 0, 1 oder 2 Karten ausgewählt sind.
        if selectedCards.count < 3 {
            
            //Wenn die Karte schon ausgewählt war, disselct und aus der Liste selectedCards entfernen.
            if chosenCard.isSelected && selectedCards.count < 3{
                chosenCard.isSelected = false
                selectedCards.remove(chosenCard)
                score -= 1
                //Wenn nicht, dann füge die Karte zur Liste hinzu
            }else{
                selectedCards.insert(chosenCard)
                chosenCard.isSelected = true
            }
            //Wenn schon 3 Karten selected sind, dann überpüfe ob ein Set vorliegt.
            //Wenn die Set-Kriterien nicht erfüllt sind, dann "entwähle" jede Karte, leere die Liste mit den ausgewählten Karten. Wenn eine weitere Karte gedrückt wurde, dann füge diese als erstes Element zur Liste der slectedCards hinzu.
            if selectedCards.count == 3{
                
                let checkForSetResult = checkForMatch(for: selectedCards)
                if checkForSetResult == true {
                    
                    successfulSetinGame = true
                    
                    if cardsInGame.count <= 12 {
                        score += 3
                    }else{
                        score += 2
                    }
                    
                    for card in selectedCards{
                        card.matchState = true
                    }
                }else if checkForMatch(for: selectedCards) == false {
                    successfulSetinGame = false
                    score -= 5
                    
                    for card in selectedCards{
                        card.matchState = false
                    }
                }
            }
        }else{
            if successfulSetinGame == false {
                for card in selectedCards {
                    card.isSelected = false
                    card.matchState = nil
                }
                selectedCards.removeAll()
                chosenCard.isSelected = true
                selectedCards.insert(chosenCard)
            }else{
                addNewCards()
            }
        }
    }
    
    mutating func searchForSetOnDeck(){
        
        var combinationCnt = 0
        var tempCards = Set<Card>()
        setsOnDeck.removeAll()

        for j in 0..<cardsInGame.count{
            for i in (j+1)..<cardsInGame.count{
                for k in (i+1)..<cardsInGame.count{
                    
                    combinationCnt += 1
                    
                    tempCards.removeAll()
                    
                    tempCards.insert(cardsInGame[k])
                    tempCards.insert(cardsInGame[i])
                    tempCards.insert(cardsInGame[j])

                    if checkForMatch(for: tempCards){
                        setsOnDeck.append(tempCards)
                    }
                }
            }
        }
    }
    
    mutating func makeHint(){
        
        score -= 2
        
        guard var randomSetOnDeck = setsOnDeck.randomElement() else {return}
        
        cardsInGame.forEach{$0.isHinted = false}
        
        for _ in 0...1 {
            randomSetOnDeck.removeFirst().isHinted = true
        }
    }
    
    
    
    private mutating func checkForMatch(for cardsToCheck: Set<Card>) -> Bool {
        
        if cardsToCheck.count == 3 {
            
            let firstCard = cardsToCheck[cardsToCheck.startIndex]
            let secondCard = cardsToCheck[cardsToCheck.index(after: cardsToCheck.startIndex)]
            let thirdCard = cardsToCheck[cardsToCheck.index(cardsToCheck.startIndex, offsetBy: cardsToCheck.count-1)]
            
            if (firstCard.sign.shape == secondCard.sign.shape && firstCard.sign.shape == thirdCard.sign.shape) ||
                (firstCard.sign.shape != secondCard.sign.shape && firstCard.sign.shape != thirdCard.sign.shape && secondCard.sign.shape != thirdCard.sign.shape) {
                if (firstCard.sign.color == secondCard.sign.color && firstCard.sign.color == thirdCard.sign.color) ||
                    (firstCard.sign.color != secondCard.sign.color && firstCard.sign.color != thirdCard.sign.color && secondCard.sign.color != thirdCard.sign.color) {
                    if (firstCard.sign.shading == secondCard.sign.shading && firstCard.sign.shading == thirdCard.sign.shading) ||
                        (firstCard.sign.shading != secondCard.sign.shading && firstCard.sign.shading != thirdCard.sign.shading && secondCard.sign.shading != thirdCard.sign.shading) {
                        if (firstCard.numberOfSigns == secondCard.numberOfSigns && firstCard.numberOfSigns == thirdCard.numberOfSigns) ||
                            (firstCard.numberOfSigns != secondCard.numberOfSigns && firstCard.numberOfSigns != thirdCard.numberOfSigns && secondCard.numberOfSigns != thirdCard.numberOfSigns) {
                            print("MATCH")
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    //Wenn schon drei Karten ausgewählt sind, ersetz die passenden oder füge solange 3 neue hinzu
    mutating func addNewCards() {
    
        cardsInGame.forEach{$0.isHinted = false}
        
        //Wenn ein Set vorliegt ersetze die gematchten Karten durch drei neue
        if successfulSetinGame {
            
            successfulSetinGame = false
            
            if cards.count > 0 && cardsInGame.count <= 12{
                
                for card in selectedCards{
                    let newCard = cards.remove(at: 0)
                    newCard.isVisible = true
                    cardsInGame[cardsInGame.firstIndex(of: card)!] = newCard
                }
            }else{
                for card in selectedCards{
                    card.isVisible = false
                    card.isSelected = false
                    cardsInGame.remove(at: cardsInGame.firstIndex(of: card)!)
                }
            }
        }else{
            if cardsInGame.count < 24 {
                for card in cardsInGame{
                    card.isSelected = false
                }
                
                for _ in 0...2{
                    let card = cards.remove(at: 0)
                    card.isVisible = true
                    cardsInGame.append(card)
                }
            }
        }
        
        searchForSetOnDeck()
        
        selectedCards.removeAll()
    }
    
    //Erstellen eines neuen Spiels
    init(){
        
        //Für die Anzahl, Zeichen, Farbe und Füllung durchlaufen und in jeder Kombination eine Karte erstellen. Hier werden alle Karten erstellt
        for i in 1...3 {
            for j in 1...3 {
                for k in 1...3 {
                    for v in 1...3{
                        let card = Card(sign: CardSign.init(shape: Shape(rawValue: j)!, shading: Shading(rawValue: k)!, color: Color(rawValue: v)!), numberOfSigns: i)
                        cards.append(card)
                        cards.shuffle()
                    }
                }
            }
        }
        
        //Am Anfang eines sollen nur 12 Karten auf dem Tisch liegen. Diese werden hier "ausgeteilt"
        for _ in 1...12 {
            let card = cards.removeFirst()
            cardsInGame.append(card)
        }
        cardsInGame.forEach(){$0.isVisible = true}
        
        searchForSetOnDeck()
    }
}
