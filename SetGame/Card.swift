//
//  Card.swift
//  SetGame
//
//  Created by Alexander Ehrlich on 09.09.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

class Card: Hashable {
    
    var hashValue: Int {
        return identifier
    }
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    //Eigenschaften der Karte
    var sign: CardSign
    var numberOfSigns: Int
    var identifier: Int
    
    //Zustände der Karte
    var matchState : Bool?
    var isVisible = false
    var isSelected = false
    var isHinted = false
   
    
    init(sign: CardSign, numberOfSigns: Int) {
        self.sign = sign
        self.numberOfSigns = numberOfSigns
        self.identifier = Card.createUniqueIdentifier()
    }
    
    private static var uniqueIdentifier = 0
    private static func createUniqueIdentifier() -> Int{
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
}
