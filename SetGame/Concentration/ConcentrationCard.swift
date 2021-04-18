//
//  Card.swift
//  ConcentrationGame
//
//  Created by Alexander Ehrlich on 23.06.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

//Der Typ Card implementiert das Protokoll Hashable um dirket vergleichbar gemacht zu werden
struct ConcentrationCard: Hashable {
    
    //Diese Funktion erstellt einen unique identifier für jede Instanz dieses struct
    var hashValue: Int {
        return identifier
    }
    
    //Diese Funktion macht den Typ Card vergleichabr. Das "==" das man immer benutzt ist genau das.
    static func ==(lhs: ConcentrationCard, rhs: ConcentrationCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false                //Jede Karte hat die Eigenschaft, ob sie umgedreht ist odern icht
    var isMatched = false               //Jede KArte hat die Eigenschaft, ob sie umgedreht ist oder nicht
    private var identifier: Int         //Jede Karte hat einen Unique Identifier --> Gleichzeitig der Hash Value
    var hasBeenInvolvedInMismatch = false //Jede KArte kann schonmal in ein Missmatch involviert gewesen sein
    
    
    //Mit dieser Methode wird bei jeder Instanzierung der Cnt inkrmentiert. Da es die Variable für den Typ nur einmal gibnt (static) gibt es jeden identifier nur einmal!
    private static var uniqueIdentifier = 0
    private static func createUniqueIdentifier() -> Int{
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
    
    
    //Ber der Initialöisierung erhält dann jede KArte ihren Unique Identifier
    init() {
        self.identifier = ConcentrationCard.createUniqueIdentifier()
    }
    
}
