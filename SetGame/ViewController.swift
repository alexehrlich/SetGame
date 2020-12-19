//
//  ViewController.swift
//  SetGame
//
//  Created by Alexander Ehrlich on 09.09.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonVerticalStack.frame.size.height = view.frame.size.height/2
        newGameButtonOutlet.layer.cornerRadius = 5
        dealNewCardButtonOutlet.layer.cornerRadius = 5
        cheatButtonOutlet.layer.cornerRadius = 5

        for index in cardButtons.indices {
            cardButtons[index].layer.cornerRadius = 5
            
            if index > 11 {
                cardButtons[index].setTitle("", for: .normal)
                cardButtons[index].layer.backgroundColor = UIColor.clear.cgColor
                cardButtons[index].isUserInteractionEnabled = false
            }
        }
        updateViewFromModel()
    }
    
    
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var buttonVerticalStack: UIStackView!
    @IBOutlet weak var dealNewCardButtonOutlet: UIButton!
    @IBOutlet weak var newGameButtonOutlet: UIButton!
    @IBOutlet weak var cheatButtonOutlet: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    var game = SetGame()
    
    @IBAction func cardButtonPressed(_ sender: UIButton) {
        
        let chosenCardIndex = cardButtons.firstIndex(of: sender)!
        game.chooseCard(at: chosenCardIndex)
        updateViewFromModel()
    }
    
    @IBAction func dealNewCardsButtonPressed(_ sender: UIButton) {
        game.addNewCards()
        updateViewFromModel()
    }
    
    @IBAction func startNewGameButtonPressed(_ sender: UIButton) {
        
        game = SetGame()
        updateViewFromModel()
    }
    
    @IBAction func cheatButtonPressed(_ sender: UIButton) {
        
        game.makeHint()
        updateViewFromModel()
    }
    
    
    func updateViewFromModel(){

        scoreLabel.text = "Score: \(game.score)"
        
        
        if (game.cardsInGame.count == 24 && !game.successfulSetinGame) || game.cards.count == 0 || game.setsOnDeck.count != 0{
            dealNewCardButtonOutlet.isUserInteractionEnabled = false
            dealNewCardButtonOutlet.layer.backgroundColor = UIColor.red.withAlphaComponent(0.1).cgColor
        }else{
            dealNewCardButtonOutlet.isUserInteractionEnabled = true
            dealNewCardButtonOutlet.layer.backgroundColor = UIColor.red.withAlphaComponent(1).cgColor
        }
        
        for index in cardButtons.indices {
            
            let button = cardButtons[index]
            
            if index < game.cardsInGame.count {
                
                let card = game.cardsInGame[index]
                
                if card.isVisible {
                    button.layer.backgroundColor = UIColor.white.cgColor
                    button.isUserInteractionEnabled = true
                    button.setAttributedTitle(createAttributedString(for: card), for: .normal)
                }else{
                    button.layer.backgroundColor = UIColor.clear.cgColor
                    button.isUserInteractionEnabled = false
                    button.layer.borderWidth = 0
                    button.setAttributedTitle(nil, for: .normal)
                    button.setTitle("", for: .normal)
                }
                
                if card.isSelected {
                    button.layer.borderWidth = 5
                    button.layer.borderColor = UIColor.black.cgColor
                    
                    if card.matchState == true{
                        button.layer.borderWidth = 5
                        button.layer.borderColor = UIColor.green.cgColor
                        
                        //Enable Deal more cards button in case of set match
                        dealNewCardButtonOutlet.isUserInteractionEnabled = true
                        dealNewCardButtonOutlet.layer.backgroundColor = UIColor.red.withAlphaComponent(1).cgColor
                        
                    }else if card.matchState == false{
                        button.layer.borderWidth = 5
                        button.layer.borderColor = UIColor.red.cgColor
                    }else{
                        button.layer.borderWidth = 5
                    }
                }else{
                    
                    if card.isHinted{
        
                        button.layer.borderWidth = 5
                        button.layer.borderColor = UIColor.yellow.cgColor
                    }else {
                        button.layer.borderWidth = 0
                    }
                }
                
            }else{
                button.layer.backgroundColor = UIColor.clear.cgColor
                button.layer.borderWidth = 0
                button.isUserInteractionEnabled = false
                button.setTitle("", for: .normal)
                button.setAttributedTitle(nil, for: .normal)
            }
        }
    }
    
    
    func createAttributedString(for card: Card) -> NSAttributedString {
        
        var attributedString = NSAttributedString()
        
        var strokeWidth = 1
        var color = UIColor.blue
        var shape = "▲"
        
        
        switch card.sign.color {
        
        case .blue: color = .blue
        case .green: color = .green
        case .red: color = UIColor.red
            
        }
        
        switch card.sign.shading {
        
        case .empty:
            strokeWidth = 5
        case .filled, .striped:
            strokeWidth = -1
        }
        
        switch card.sign.shape{
        
        case .circle: shape = "●"
        case .square: shape = "■"
        case .triangle: shape = "▲"
        }
        
        
        if card.sign.shading == .striped {
            let attributes : [NSAttributedString.Key : Any] = [
                .foregroundColor : color.withAlphaComponent(0.15)
            ]
            
            attributedString = NSAttributedString(string: shape * card.numberOfSigns, attributes: attributes)
            
        }else{
            let attributes : [NSAttributedString.Key : Any] = [
                .strokeWidth: strokeWidth,
                .foregroundColor : color
            ]
            
            attributedString = NSAttributedString(string: shape * card.numberOfSigns, attributes: attributes)
        }
        
        return attributedString
    }
}



extension String {
    
    static func *(left: String, right: Int) -> Self{
        
        if right <= 0 {
            return ""
        }else{
            return String(repeating: left, count: right)
        }
    }
}






