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
    
    var newCards = [Card]()
    var matchingIndices = [Int]()

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
        }else{//Wenn 3 Karten ausgewählt sind
            
            //Wenn kein Set mit den ausgewählten Karten vorliegt, dann setze alles zurück
            if successfulSetinGame == false {
                
                for card in selectedCards {
                    card.isSelected = false
                    card.matchState = nil
                }
                selectedCards.removeAll()
                chosenCard.isSelected = true
                selectedCards.insert(chosenCard)
            }else{
                //updateCards()
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
    
    mutating func resetAllCards(){
        
        selectedCards.removeAll()
        
        cardsInGame.forEach(){
            $0.isHinted = false
            $0.isSelected = false
            $0.matchState = nil
        }
    }
    
    mutating func removeSelectedCards(){
        for card in selectedCards{
            cardsInGame.remove(at: cardsInGame.firstIndex(of: card)!)
        }
        searchForSetOnDeck()
        successfulSetinGame = false
        selectedCards.removeAll()
    }
    
    mutating func shuffleGame(){
        
        let count = cardsInGame.count
        resetAllCards()
        cards += cardsInGame
        cards.shuffle()
        cardsInGame.removeAll()
        
        for _ in 1...count{
            cardsInGame.append(cards.remove(at: 0))
        }
        
        searchForSetOnDeck()
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
                            return true
                        }
                    }
                }
            }
        }
        return false
    }

    
    //Füge 3 Karten am Ende der bestehenden Karten hinzu
    mutating func addNewCards(){
        if cards.count > 0 {
            newCards.removeAll()
            for _ in 0...2{
                let newCard = cards.remove(at: 0)
                cardsInGame.append(newCard)
                newCards.append(newCard)
            }
        }
        
        print("CARDS Added")
        cardsInGame.forEach({print($0)})
        print("\n")
    }
    

    //Ersetze die Karten bei einem Set, wenn noch Karten vorhanden sind, oder lösche die gematchten, wenn keine mehr vorhanden sind
    mutating func updateCards() {

        newCards.removeAll()
        
        //Wenn ein Set vorliegt ersetze die gematchten Karten durch drei neue
        if successfulSetinGame {
            
            cardsInGame.forEach{$0.isHinted = false}
        
            //Wenn noch Karten im Deck sind, dann tausche sie aus
            if cards.count > 0 {
                
                for card in selectedCards{
                    matchingIndices.append(cardsInGame.firstIndex(of: card)!)
                    print("Matching Indeices: \(matchingIndices)")
                    card.isVisible = false
                    card.isSelected = false
                    
                    //Wo liegt die aktuell gematchte Karte?
                    let cardIndex = cardsInGame.firstIndex(of: card)
                    
                    //Hole eine neue Karte
                    let newCard = cards.remove(at: 0)
                    
                    //Ersetze die alte gematchte Karte mit der neuen
                    cardsInGame[cardIndex!] = newCard
                    
                    //Speichere die neuene KArten in diesem Array, damit im ViewController.swift geupdated werden kann
                    newCards.append(newCard)
                }
                
                print("CARDS UPDATED at: \(matchingIndices)")
                cardsInGame.forEach({print($0)})
                print("\n")
                
            }else{
                
                for card in selectedCards{
                    matchingIndices.append(cardsInGame.firstIndex(of: card)!)
                }
                
                //Wenn keine Karten mehr im verfügbar sind. Die neuen KArten sollen die alten sein, nur ohne die ausgewählten Karten von vorhin
                cardsInGame = cardsInGame.filter(){!selectedCards.contains($0)}
            }
            selectedCards.removeAll()
        }
        //Nach dem Update ist kein Set vom User mehr im Game
        successfulSetinGame = false
        
        //Suche mit den neuen Karten nach neuen Sets auf dem Tisch
        searchForSetOnDeck()
    }
    
    
    //Erstellen eines neuen Spiels
    init(){
        
        //Für die Anzahl, Zeichen, Farbe und Füllung durchlaufen und in jeder Kombination eine Karte erstellen. Hier werden alle Karten erstellt
        for shape in CardSign.Shape.allShapes {
            for color in CardSign.Color.allColors {
                for shading in CardSign.Shading.allShadings{
                    for v in 1...3{
                        let card = Card(sign: CardSign(shape: shape, shading: shading, color: color), numberOfSigns: v)
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
        newCards = cardsInGame
        cardsInGame.forEach(){$0.isVisible = true}
        searchForSetOnDeck()
        
        print("GAME STARTED")
        cardsInGame.forEach({print($0)})
        print("\n")
    }
}
