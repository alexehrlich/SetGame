//
//  CardCellView.swift
//  SetGame
//
//  Created by Alexander Ehrlich on 16.02.21.
//  Copyright © 2021 Alexander Ehrlich. All rights reserved.
//

import UIKit

class CardCellView: UIView {
    
    var sign: CardSign?
    let path = UIBezierPath()
    
    var signColor: UIColor{
        switch sign!.color{
        case .green: return UIColor.green
        case .purple: return UIColor.purple
        case .red: return UIColor.red
        }
    }
    
    
    override func draw(_ rect: CGRect) {

        //contentMode = .redraw
        //Draw the Path
        if let currentSign = sign {
            
            switch currentSign.shape{
            
            case .oval:
                path.addArc(withCenter: CGPoint(x: bounds.midX - bounds.width * SizeRatio.signWidthToBounds/2 + bounds.height * SizeRatio.signHeightToBounds, y: bounds.midY), radius: bounds.height * SizeRatio.signHeightToBounds, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi * 1.5, clockwise: true)
                path.addLine(to: CGPoint(x: path.currentPoint.x + bounds.width * SizeRatio.signWidthToBounds - 2 * bounds.height * SizeRatio.signHeightToBounds, y: path.currentPoint.y))
                path.addArc(withCenter: CGPoint(x: path.currentPoint.x, y: bounds.midY), radius: bounds.height * SizeRatio.signHeightToBounds, startAngle: 1.5 * CGFloat.pi, endAngle: 0.5 * CGFloat.pi, clockwise: true)
                path.close()
                
            case .diamond:
                
                path.move(to: CGPoint(x: bounds.midX - bounds.width * SizeRatio.signWidthToBounds/2, y: bounds.midY))
                path.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY - bounds.height * SizeRatio.signHeightToBounds))
                path.addLine(to: CGPoint(x: bounds.midX + bounds.width * SizeRatio.signWidthToBounds/2, y: bounds.midY))
                path.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY + bounds.height * SizeRatio.signHeightToBounds))
                path.close()
                
                
            case .squiggle:
                //Später noch richtig zeichnen
                path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.height * SizeRatio.signHeightToBounds, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            }
            
            switch currentSign.shading{
            
            case .empty:
                strokePath(path, with: currentSign.color)
                
            case .filled:
                fillPath(path, with: currentSign.color)
                
            case .striped:
                strokePath(path, with: currentSign.color)
                stripeShape()
            }
            

        }
    }
    
    func strokePath(_ path: UIBezierPath, with color: CardSign.Color){
        
        signColor.setStroke()
        path.lineWidth = bounds.width * SizeRatio.strokeWidthToBounds
        path.stroke()
    }
    
    func fillPath(_ path: UIBezierPath, with color: CardSign.Color){
      
        signColor.setFill()
        path.fill()
    }
    
    func stripeShape(){
        
        path.addClip()
        let delta = bounds.width / 20
        let stripes = UIBezierPath()
        for n in (1...40).reversed()
        {
            stripes.move(to: CGPoint(x: bounds.minY + CGFloat(n) * delta, y: 0))
            stripes.addLine(to: CGPoint(x: stripes.currentPoint.x, y: bounds.maxY))
        }
        signColor.setStroke()
        stripes.stroke()
    }
    
    
}
extension CardCellView{
    
    private struct SizeRatio{
        
        static let signHeightToBounds: CGFloat = 0.3
        static let signWidthToBounds: CGFloat = 0.8
        static let strokeWidthToBounds: CGFloat = 0.02
    }
}
