//
//  CardSign.swift
//  SetGame
//
//  Created by Alexander Ehrlich on 09.09.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

struct CardSign {
    
    private (set) var shape: Shape
    private (set) var shading: Shading
    private (set) var color: Color
    
    enum Shape: Int{
        
        case diamond = 1
        case oval
        case squiggle
        
        static var allShapes = [Shape.diamond, .oval, .squiggle]
    }

    enum Shading: Int {
        
        case filled = 1
        case empty
        case striped
        
        static var allShadings = [Shading.empty, .filled, .striped]
    }

    enum Color: Int {
        
        case purple = 1
        case red
        case green
        
        static var allColors = [Color.purple, .red, .green]
    }
}


