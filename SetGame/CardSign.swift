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
}

enum Shape: Int{
    
    case circle = 1
    case triangle
    case square
}

enum Shading: Int {
    
    case filled = 1
    case empty
    case striped
}

enum Color: Int {
    
    case blue = 1
    case red
    case green
}
