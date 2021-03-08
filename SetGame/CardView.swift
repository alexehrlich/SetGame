//
//  CardView.swift
//  SetGame
//
//  Created by Alexander Ehrlich on 16.02.21.
//  Copyright © 2021 Alexander Ehrlich. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var signCount = 2 { didSet{ setNeedsDisplay(); setNeedsLayout()} }
    var arrangedSubviews = [UIView]() { didSet{ setNeedsDisplay(); setNeedsLayout()} }
    var sign: CardSign? = CardSign(shape: .squiggle, shading: .striped, color: .purple) { didSet{ setNeedsDisplay(); setNeedsLayout()} }
    
    var cardInset: CGFloat {
        
        switch signCount{
        
        case 1: return 1
        case 2: return 0.5
        case 3: return 0
            
        default: return 0
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        let path = UIBezierPath(roundedRect: CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: bounds.height)), cornerRadius: bounds.width * 0.1)
        UIColor.white.setFill()
        path.fill()
        path.addClip()
        
        
        if let currentSign = sign {
            
            for _ in 1...signCount {
            
                let signView = CardCellView(frame: CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: bounds.height/3)))
                signView.sign = currentSign
                signView.backgroundColor = .clear
                arrangedSubviews.append(signView)
                
            }
            
            let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
            stackView.axis = .vertical
            stackView.distribution = .fillEqually  
            stackView.spacing = 0 
            stackView.alignment = .fill
            
            self.addSubview(stackView)
            


            // autolayout constraint
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: (bounds.height/3) * cardInset ),
                stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
                stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
                stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(bounds.height/3) * cardInset)
            ])
            
        }
    }
}

