//
//  ViewController.swift
//  SetGame
//
//  Created by Alexander Ehrlich on 09.09.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game = SetGame()
    var grid: Grid!
    var cards = [CardView]()
    
    
    @IBOutlet weak var dealNewCardButtonOutlet: UIButton!
    @IBOutlet weak var newGameButtonOutlet: UIButton!
    @IBOutlet weak var cheatButtonOutlet: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardArea: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dealNewCards))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(self.shuffleGame(_:)))
        self.view.addGestureRecognizer(rotation)
        
        newGameButtonOutlet.layer.cornerRadius = 5
        dealNewCardButtonOutlet.layer.cornerRadius = 5
        cheatButtonOutlet.layer.cornerRadius = 5
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        grid = Grid(layout: .aspectRatio(0.7), frame: cardArea.frame)
        updateViewFromModel()
    }
    
    @IBAction func dealNewCardsButtonPressed(_ sender: UIButton) {
        dealNewCards()
    }
    
    @objc func dealNewCards(){
        removeAllCardViews()
        game.updateCards()
        updateViewFromModel()
    }
    
    @objc func shuffleGame(_ sender: UIRotationGestureRecognizer){
        if sender.state == .ended{
            removeAllCardViews()
            game.shuffleGame()
            updateViewFromModel()
        }
    }
    
    @IBAction func startNewGameButtonPressed(_ sender: UIButton) {
        removeAllCardViews()
        game = SetGame()
        updateViewFromModel()
    }
    
    @IBAction func cheatButtonPressed(_ sender: UIButton) {
        removeAllCardViews()
        game.resetAllCards()
        game.makeHint()
        updateViewFromModel()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
           coordinator.animate(alongsideTransition: nil) { _ in
            self.removeAllCardViews()
            self.grid.frame = self.cardArea.frame
            self.updateViewFromModel()
           }
    }

    
    
    
    
    func updateViewFromModel(){
        
        grid.cellCount = game.cardsInGame.count
        
        scoreLabel.text = "Score: \(game.score)"
        
        //disable/enable deal newCards button
        if (game.cards.count == 0){
            dealNewCardButtonOutlet.isUserInteractionEnabled = false
            dealNewCardButtonOutlet.layer.backgroundColor = UIColor.red.withAlphaComponent(0.1).cgColor
        }else{
            dealNewCardButtonOutlet.isUserInteractionEnabled = true
            dealNewCardButtonOutlet.layer.backgroundColor = UIColor.red.withAlphaComponent(1).cgColor
        }
        
        for index in 0..<game.cardsInGame.count {
            
            let card = game.cardsInGame[index]
            
            let newView = CardView()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cardTapped))
            newView.addGestureRecognizer(tapGesture)
            
            cards.append(newView)
            
            
            newView.sign = card.sign
            newView.signCount = card.numberOfSigns
            
            
            newView.frame.origin = grid[index]!.origin
            newView.frame = grid[index]!.inset(by: .init(top: 5, left: 5, bottom: 5, right: 5))
            newView.backgroundColor = .clear
            newView.layer.cornerRadius = newView.bounds.width * 0.1
            
            self.view.addSubview(newView)
            
            if card.isSelected {
                newView.layer.borderWidth = 5
                newView.layer.borderColor = UIColor.black.cgColor
                
                if card.matchState == true{
                    newView.layer.borderWidth = 5
                    newView.layer.borderColor = UIColor.green.cgColor
                    
                    //Enable Deal more cards button in case of set match
                    dealNewCardButtonOutlet.isUserInteractionEnabled = true
                    dealNewCardButtonOutlet.layer.backgroundColor = UIColor.red.withAlphaComponent(1).cgColor
                    
                }else if card.matchState == false{
                    newView.layer.borderWidth = 5
                    newView.layer.borderColor = UIColor.red.cgColor
                }else{
                    newView.layer.borderWidth = 5
                }
            }else{
                
                if card.isHinted{
                    
                    newView.layer.borderWidth = 5
                    newView.layer.borderColor = UIColor.orange.cgColor
                }else {
                    newView.layer.borderWidth = 0
                }
            }
            
        }
    }
    
    func removeAllCardViews(){
        for card in cards{
            card.removeFromSuperview()
        }
        cards.removeAll()
    }
    
    
    @objc func cardTapped(_ sender: UITapGestureRecognizer){
        
        for (index, rect) in grid.cellFrames.enumerated(){
            if rect.contains(sender.location(in: self.view)) {
                game.chooseCard(at: index)
                updateViewFromModel()
                let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                    if self.game.successfulSetinGame{
                        self.removeAllCardViews()
                        self.game.updateCards()
                        self.updateViewFromModel()
                    }
                }
                

            }
        }
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}







