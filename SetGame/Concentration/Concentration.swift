//
//  Concentration.swift
//  ConcentrationGame
//
//  Created by Alexander Ehrlich on 23.06.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation


class Concentration {
    
    //Das Spiel hat zu Beginn ein leeres Array vom Typ 'Card'
    //private(set) --> Read Only für andere Objekte im Projekt
    private(set) var cards = [ConcentrationCard]()
    private(set) var score = 0
    private(set) var flipCount = 0
    
    
    //Computed-Property. Beim Aufruf(nur innerhalb der Klasse)
    private var indexOfOneANdOnlyFaceUpCard: Int?{
        get{
            return cards.indices.filter{ cards[$0].isFaceUp == true}.oneAndOnly
        }
        set{
            for index in cards.indices{                         //Beim Setzen wird jede Karte im Card-Array durchgegenagen
                
                cards[index].isFaceUp = (index == newValue)     // Der gesetzte WErt (newValue) bei dem man die Karte umdrehen will, wird
                                                                //wird dann mit dem aktuellen Index aus dem Schleifendurchlauf vergleichen
            }                                                   //Ist das true, wird die boolsche var isFaceUp auf true gesetzt, wenn nicht
        }                                                       //dann auf false
    }
    
    //In dieser Methode werden die umgedrehten Karten überprüft
    func chooseCards(at index: Int){
        
        //Da man eine Karte umdreht, wird der Counter um 1 inkrementiert
        flipCount += 1
        
        //Wenn die ausgewählte Karte noch nicht "gematched wurde", dann...
        if !cards[index].isMatched {
            
            //Optional-Binding. Wenn indexOfOneAndOnlyFaceUpCard nciht nil ist (also eine KArte umgedreht ist), dann...
            if let matchIndex = indexOfOneANdOnlyFaceUpCard{
                
                //Wenn die Karte der schon umgedrehten Karte und die aktuell ausgewählten Karte gleich sind. Diese können direkt vergleichen werden, da der Typ Card das Hashable und damit implizit das Equotable protocol implementiert
                if cards[matchIndex] == cards[index], matchIndex != index{
                    
                    score += 2 //Zähle den Score beim Treffer um 2 hoch.
                    cards[matchIndex].isMatched = true //Markiere die bereits umgedrehte Karte als "gematched"
                    cards[index].isMatched = true //Markiere die aktuell umgedrehte Karte als "gematched"
                    
                    
                 //Wenn die Karte der schon umgedrehten Karte und die aktuell ausgewählten Karte NICHT gleich sind, dann
                }else{
                    
                    //Wenn einer der Karten schon mal falsch aufgedeckt wurden, dann..
                    if cards[matchIndex].hasBeenInvolvedInMismatch == true || cards[index].hasBeenInvolvedInMismatch == true{
                        //Ziehe vom Score 1 Punkt ab
                        score -= 1
                    }
                    
                    //Markiere beide Karten, dass sie fehlerhaft zugeordnet wurden
                    cards[matchIndex].hasBeenInvolvedInMismatch = true
                    cards[index].hasBeenInvolvedInMismatch = true
                }
                
                //Drehe die ausgewählte Karte zusätzlich zur schon umgedrehten (indexOfOneAndOnly...) um
                cards[index].isFaceUp = true
            
            //Wenn indexOfOneANdOnlyFaceUpCard == nil, dann sind entweder keine Karten oder zwei Karten umgedreht. Dann...
            }else{
                
                //Setze die aktuell ausgewählte Karte als die einzig umgedrehte. In dem Setter von indexOfOneANdOnlyFaceUpCard werden dann alle KArten bis auf die ausgewählte faceDown (isFaceUp = flase).
                indexOfOneANdOnlyFaceUpCard = index
            }
            
        }
    }
    
    //Der Initializer für ein neues Spiel initialisert ein Kartendeck mit einer Anzhal von Kartenpaaren, wobei jede KArte identishc (Identifier) 2 mal vorkommt
    init(numberOfPairedCards: Int){
        for _ in 0..<numberOfPairedCards {
            let card = ConcentrationCard() //Bei der Initilaisierung einer Card wird ein uniq identiefier mithilfer einer static var und static func generiert.
            cards += [card, card] //Hier wird eine KArte 2 mal hinzugefügt. Es existieren zwei Karten mit demselben Identifier
        }
        
        //Das Kartendeck wird gemischt.
        cards.shuffle()
    }
    
}

extension Collection {
    
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
