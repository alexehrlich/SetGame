//
//  ConcentrationThemeChooserViewController.swift
//  ConcentrationGame
//
//  Created by Alexander Ehrlich on 09.03.21.
//  Copyright © 2021 Alexander Ehrlich. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    let themes = [
        "Countries" : ["🇩🇪","🇬🇷","🇵🇷","🇬🇧","🇺🇸","🇹🇷","🇪🇸","🇵🇱","🇵🇹","🇫🇷"],
        "Animals" : ["🐶","🐱","🐻","🐼","🐹","🐵","🦊","🐰","🐨","🦁"],
        "Faces" : ["😰","😂","😎","😍","🤪","🤩","🤯","🤗","🥶","😴"]
    ]
    
    @IBAction func chooseThemeButtonPressed(_ sender: UIButton) {
        
        if let cvc = splitViewDetailConcentrationViewController{
            if let themeName = sender.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
        }else if let cvc = lastShownConctentraionVC{
            if let themeName = sender.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        }else{
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController?{
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastShownConctentraionVC: ConcentrationViewController?
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Choose Theme"{
            
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                if let destVC = segue.destination as? ConcentrationViewController {
                    lastShownConctentraionVC = destVC
                    destVC.theme = theme
                }
            }
        }
        
    }
}
