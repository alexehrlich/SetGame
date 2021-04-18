//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Alexander Ehrlich on 23.06.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController, UISplitViewControllerDelegate {
    
    
    //Hier wird eine Instanz eines Spiels erstellt --> Kartenstapel wird initialisiert. Diese Variable ist lazy, denn sie kann erst zu einem späteren Zeitpunkt bestimmt werden. Die Anzahl der Card Buttons ist nämlich noch nciht bekannt. Sobald diese bekannt ist, kann concentration initialisiert werden.
    lazy var concentration = Concentration(numberOfPairedCards: cardButtons.count/2)
    
    //Dieses Array enthällt alle "Themes" für das Spiel. Jede Zeile entspricht einem Theme.
    var emojiThemes = [
        ["🧠","💀","👹","🎃","👻","👀","🧟‍♀️","🦇","🍬","🍭"],
        ["🎂","🍩","🍪","🍦","🍧","🍡","🍮","🍿","🍫","🍭"],
        ["🐶","🐱","🐻","🐼","🐹","🐵","🦊","🐰","🐨","🦁"],
        ["🌿","🌲","🍀","🌵","🌻","🌷","🌸","🥀","🌹","🍁"],
        ["😰","😂","😎","😍","🤪","🤩","🤯","🤗","🥶","😴"],
        ["🇩🇪","🇬🇷","🇵🇷","🇬🇧","🇺🇸","🇹🇷","🇪🇸","🇵🇱","🇵🇹","🇫🇷"],
    ]
    
    
    var theme: [String]? {
        didSet{
            chosenEmojiTheme = theme ?? []
            emojisForGame = [:]
            updateViewFromModel()
        }
    }
    
    
    //Das gewählte Theme wird zu Beginn mit dem Haloween Theme befüllt.
    var chosenEmojiTheme = ["🧠","💀","👹","🎃","👻","👀","🧟‍♀️","🦇","🍬","🍭"]
    
    //Ein leeres dictionary mit dem Key vom Typ Card. Das geht da Card nun Hashable ist.
    var emojisForGame = [ConcentrationCard : String]()
    
    @IBOutlet private var cardButtons: [UIButton]! //Array von UIButton. Auf dieses kann mit UIButton zugegriffen werden.
    @IBOutlet weak private var flipCountLabel: UILabel! {
        //Sobald UIKit die Variable zuweist, wird didSet aufgerufen, wenn die Connection von iOS zwischen View und Controller erstllt. Ist nötig, da die Attribute erst nach dem ersten Setzen in der App mit der lokalen Var gesetzt werden würden.
        didSet{
            let attributes : [NSAttributedString.Key : Any] = [
                .strokeWidth : 5,
                .strokeColor : UIColor.orange
            ]
            let attributedString = NSAttributedString(string: "FlipCount: \(concentration.flipCount)", attributes: attributes)
            flipCountLabel.attributedText = attributedString
        }
    }
    @IBOutlet weak private var scoreLabel: UILabel!
    
    //Diese Funktion wird aufgerufen, wenn eine Karte(UIButton) gedrückt wird.
    @IBAction private func touchCard(_ sender: UIButton) {
        
        //Der Zugriff auf das Array mittles des Button (Sender) liefert einen Int? zurück. Wenn dieser nicht nil ist, dann...
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            
            //Überprüfe die Karte mit der Methode choseCards() der Klasse Concentration..
            concentration.chooseCards(at: cardNumber)
            
            //Auf Basis der Eigentschaften der Karten, werden diese bewertet und neu gesetzt. Nach deren Aktualisierung, muss die UI geupdatet werden. DAs geht mit der Methode updateViewFromModel()
            updateViewFromModel()
            
            //Wenn der Zugriff auf das Array nciht klappt, wird folgendes zurückgegeben
        }else{
            print("Card not available.")
        }
    }
    
    //Diese Methode hält das Model und die View in Sync. Nach jeder ausgewählten KArte werdeb die Eigenschaften (isMatched, isFacUp..) aktualisiert. Diese Methode stellt diese Aktualisierung in der UI dar.
    private func updateViewFromModel(){
        if cardButtons != nil {
            let attributes : [NSAttributedString.Key : Any] = [
                .strokeWidth : 5,
                .strokeColor : UIColor.darkGray
            ]
            
            let attributedString = NSAttributedString(string: "FlipCount: \(concentration.flipCount)", attributes: attributes)
            flipCountLabel.attributedText = attributedString
            
            scoreLabel.text = "Score: \(concentration.score)"
            
            //Es werden alle Idizes der vorhandenen Buttons durchgegangen. Es gibt genau so viele Card-Objekte wie es Card-Buttons gibt, das Spiel mit der Anzahl der Card-Buttons initialisiert wurde.
            for index in cardButtons.indices {
                
                //Hier werden der Button und die Karte synchronisiert
                let button = cardButtons[index]
                let card = concentration.cards[index]
                
                //Wenn die Karte faceUp ist, wird der Titel des Button
                if card.isFaceUp {
                    button.backgroundColor = UIColor.lightGray
                    
                    //Mit der Funktion getEmoji wird aus dem Theme Array für die Karte ein zufälliges Element aus ChosesEmojiTheme gewählt(und gelöscht) und dieser Karte in dem Dictionary emojisForGame zugeordnet. Dieses Emoji kann dann keiner anderen KArte zugeordent werden, da es nicht mehr aus dem anderen Array extrahiert werden kann.
                    
                    //Setzt den Titel gleich dem Emoji
                    button.setTitle(getEmoji(for: card), for: .normal)
                    
                    //Wenn die Karte faceDown ist, zeige die Rückseite (orange und kein Text)
                }else{
                    button.backgroundColor = card.isMatched ? UIColor.clear : UIColor.systemBlue
                    button.setTitle(nil, for: .normal)
                }
            }
        }
    }
    
    //Diese Funktion ordnet jeder KArte bei deren ersten Aufruf ein Emoji fest zu
    private func getEmoji(for card: ConcentrationCard) -> String {
        
        //Wenn der Eintrag für diese KArte noch nciht existiert, also nil ist und das Array noch mindestens 1 Element besitzt,dann ...
        if emojisForGame[card] == nil, chosenEmojiTheme.count > 0 {
            
            //Erstelle einen neuen Eintrag im Dictioanry und ordne ein zufällig ausgewähltes Emoji aus chosenEmojiTheme zu. Dort wird es dann gelöscht und steht ncht zur weiteren Vergabe für eine Karte zu Verfügung.
            emojisForGame[card] = chosenEmojiTheme.remove(at: chosenEmojiTheme.count.arc4random)
        }
        
        //Gebe das Emoji(String) zurück. Wenn das nil ist, dann gib ein Fragezeichen zurück.
        return emojisForGame[card] ?? "?"
    }
    
    //Wenn dieser Button betätigt wird, dann wird ein neues Spiel gestartet
    @IBAction private func startNewGame(_ sender: UIButton) {
        
        //Initilaisiere ein neues Spiel. Alle Karten sind face down, score=0,flipCnt = 0
        concentration = Concentration(numberOfPairedCards: cardButtons.count/2)
        
        //Wähle das zufällige neue Them aus. randomElement() isz beu in Swift5
        chosenEmojiTheme = emojiThemes.randomElement()!
        
        
        //Setze die ausgewählten Emojis vom alten Spiel zurück
        emojisForGame = [ConcentrationCard : String]()
        
        //Aktualisieren das View mit dem neuen Spiel
        updateViewFromModel()
    }
    
}


//Extension, um einfach eine zufällige Zahl auf Basis eines Integer-Wertes zu bekommen
//Die extension ist aufgrund von randomElement() in Swift 5 nicht mehr notwendig
extension Int {
    
    var arc4random: Int {
        
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
    }
}

