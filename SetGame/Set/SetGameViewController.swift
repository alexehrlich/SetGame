//
//  ViewController.swift
//  SetGame
//
//  Created by Alexander Ehrlich on 09.09.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class SetGameViewController: UIViewController {
    
    var game = SetGame()
    lazy var grid = Grid(layout: .aspectRatio(0.7), frame: cardArea.frame)
    
    //Maybe optional to mark "empty card spaces"
    var visibleCardViews = [CardView]()
    var cardsToAdd = [CardView : Int]()
    var cardsToRemove = [CardView]()
    
    //MARK: IBOUTLETS
    @IBOutlet weak var dealNewCardButtonOutlet: UIButton!
    @IBOutlet weak var newGameButtonOutlet: UIButton!
    @IBOutlet weak var cheatButtonOutlet: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardArea: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Layout the UI
        newGameButtonOutlet.layer.cornerRadius = 5
        dealNewCardButtonOutlet.layer.cornerRadius = 5
        cheatButtonOutlet.layer.cornerRadius = 5
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //brings the initial cards on the deck
        updateViewFromModel()
    }
    

    @IBAction func dealNewCardsButtonPressed(_ sender: UIButton) {
        dealNewCards()
    }
    
    @IBAction func startNewGameButtonPressed(_ sender: UIButton) {
        game = SetGame()
        removeAllCardViews()
        visibleCardViews.removeAll()
        updateViewFromModel()
    }
    
    @IBAction func cheatButtonPressed(_ sender: UIButton) {
        game.resetAllCards()
        game.makeHint()
        updateViewFromModel()
    }
    
    @objc func dealNewCards(){
        game.resetAllCards()
        game.addNewCards()
        updateViewFromModel()
    }
    
    

    //Gets calles when the device is rotated --> Redraw
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { _ in
            self.grid.frame = self.cardArea.frame
            self.rearrangeCardViews(in: self.grid)
            //Alle Karten neu zeichnen
            self.visibleCardViews.forEach { (card) in
                card.setNeedsDisplay()
            }
            self.updateViewFromModel()
        }
    }
    
    
    //Updates the View From the model
    func updateViewFromModel(){

        cardsToAdd.removeAll()

        //Recalculate the grid
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

        //Wenn im game Model neue Karten hinzugefügt wurden, dann müssen die CardViews geupdatet werden.
        if visibleCardViews.count < game.cardsInGame.count{

            let newCards = self.createNewCardViews()
            let indicies = Array(self.visibleCardViews.count...self.game.cardsInGame.count-1)
    
            //rearrange the current views in cards-array
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                
                self.rearrangeCardViews(in: self.grid)
                //Alle Karten neu zeichnen

                for (index, card) in newCards.enumerated(){
                    self.cardsToAdd[card] = indicies[index]
                    self.visibleCardViews.append(card)
                }
                
                self.dealNewCard()
                
                self.visibleCardViews.forEach { (card) in
                    card.setNeedsDisplay()
                }
            }
            updateCardViews()
            
        }else if visibleCardViews.count == game.cardsInGame.count{
          
            if game.matchingIndices.count == 3 {
                
                let newCards = self.createNewCardViews()
                let indicies = self.game.matchingIndices
                
                
                //rearrange the current views in cards-array
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [self] in

                    //KArten nicht mehr sichtbar, aber immer noch im visible cardView Array
                    self.removeCardsWithAnimationAfterMatch()

                    //Ersetze die bereits vom UI entfernten Cardviews mit den neuen
                    for (index, card) in newCards.enumerated(){
                        
                        let tempIndex = indicies[index]
                        self.cardsToAdd[card] = tempIndex
                        self.cardsToRemove.append(self.visibleCardViews[tempIndex])
                        self.visibleCardViews[tempIndex] = card
                    }
                
                    self.dealNewCard()
                    self.visibleCardViews.forEach { (card) in
                        card.setNeedsDisplay()
                    }
                }

                cardsToRemove.forEach({$0.removeFromSuperview()})
                cardsToRemove.removeAll()
                game.matchingIndices.removeAll()
            }
            updateCardViews()
            
        }else if visibleCardViews.count > game.cardsInGame.count{
            
            print(game.cardsInGame.count)
            print(visibleCardViews.count)
            
            //removes CardVies from Superview but remain in visible CardViews
            removeCardsWithAnimationAfterMatch()
            
            //Now remove the cards from visible CardViews
            for index in game.matchingIndices {
                cardsToRemove.append(visibleCardViews[index])
            }
            print(cardsToRemove.count)
            //remove the old cardViews from the array
            visibleCardViews = visibleCardViews.filter({!cardsToRemove.contains($0)})
            print(visibleCardViews.count)

            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.rearrangeCardViews(in: self.grid)
                self.visibleCardViews.forEach { (card) in
                    card.setNeedsDisplay()
                }
            }
            
            cardsToRemove.forEach({$0.removeFromSuperview()})
            cardsToRemove.removeAll()
            game.matchingIndices.removeAll()
        }
    }
    
    private func dealNewCard(){
        
        if let cardAtPosition = cardsToAdd.first{
   
            let card = cardAtPosition.key
            let index = cardAtPosition.value
            
            cardsToAdd.removeValue(forKey: card)
            self.view.isUserInteractionEnabled = false
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 0, options: .curveEaseInOut) {
                card.frame = self.grid[index]!.inset(by: .init(top: 5, left: 5, bottom: 5, right: 5))
            } completion: { (position) in
                self.view.isUserInteractionEnabled = true
                self.dealNewCard()
                UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                    card.isFaceUp = true
                })
            }
        }
    }

    
    private func updateCardViews(){
        
        for index in 0..<game.cardsInGame.count {
            
            let card = game.cardsInGame[index]
            let cardView = visibleCardViews[index]
            
            cardView.layer.cornerRadius = cardView.bounds.width * 0.1
            
            if card.isSelected {
                
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                    cardView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
                }

                cardView.layer.borderWidth = 5
                cardView.layer.borderColor = UIColor.black.cgColor
                
                if card.matchState == true{
                    cardView.layer.borderWidth = 5
                    cardView.layer.borderColor = UIColor.green.cgColor
                    
                    //Enable Deal more cards button in case of set match
                    dealNewCardButtonOutlet.isUserInteractionEnabled = true
                    dealNewCardButtonOutlet.layer.backgroundColor = UIColor.red.withAlphaComponent(1).cgColor
                    
                }else if card.matchState == false{
                    cardView.layer.borderWidth = 5
                    cardView.layer.borderColor = UIColor.red.cgColor
                }else{
                    cardView.layer.borderWidth = 5
                }
            }else{
                
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                    cardView.transform = CGAffineTransform.identity
                }
                
                if card.isHinted{
                    cardView.layer.borderWidth = 5
                    cardView.layer.borderColor = UIColor.orange.cgColor
                }else {
                    cardView.layer.borderWidth = 0
                }
            }
        }
    }

    private func rearrangeCardViews(in frame: Grid){
        
        for index in 0..<visibleCardViews.count {
            let card = visibleCardViews[index]
            self.view.addSubview(card)
            card.frame.origin = grid[index]!.origin
            card.frame = grid[index]!.inset(by: .init(top: 5, left: 5, bottom: 5, right: 5))
            card.backgroundColor = .clear
            card.layer.cornerRadius = card.bounds.width * 0.1
        }
    }
    
    private func removeAllCardViews(){
        for subview in self.view.subviews{
            if let convertible = subview as? CardView{
                convertible.removeFromSuperview()
            }
        }
    }

    private func createNewCardViews() -> [CardView]{

        var tempView = [CardView]()

        for card in game.newCards{

            let newView = CardView()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cardTapped))
            newView.addGestureRecognizer(tapGesture)
            
            newView.sign = card.sign
            newView.signCount = card.numberOfSigns
            newView.backgroundColor = .clear
            
            newView.frame = grid[0]!.inset(by: .init(top: 5, left: 5, bottom: 5, right: 5))
            newView.frame.origin.y = self.view.frame.height
            newView.center.x = self.view.center.x
            
            tempView.append(newView)
            
            self.view.addSubview(newView)
        }
        return tempView
    }
    
    
    @objc func cardTapped(_ sender: UITapGestureRecognizer){
        
        for (index, rect) in grid.cellFrames.enumerated(){
            if rect.contains(sender.location(in: self.view)) {
                game.chooseCard(at: index)
                game.updateCards()
                updateViewFromModel()
            }
        }
    }
    
    private func removeCardsWithAnimationAfterMatch(){
        for index in game.matchingIndices{
            visibleCardViews[index].removeFromSuperview()
        }
    }
}



extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}







