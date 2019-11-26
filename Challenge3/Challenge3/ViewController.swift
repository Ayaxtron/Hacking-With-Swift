//
//  ViewController.swift
//  Challenge3
//
//  Created by Ayax Alexis Casarrubias Rodríguez on 26/11/19.
//  Copyright © 2019 Ayax Alexis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
    @IBOutlet var labelWord: UILabel!
    var word = "YELLOW"
    var chances = 7
    var hint = ""
    var guess = [String?]()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for letter in word{
            if word.contains(guess[count]){
                hint += "\(guess[count])"
            }else{
                hint += "?"
            }
            count += 1
        }
        labelWord.text? = hint
    }

    @IBAction func button(_ sender: Any) {
        var ac = UIAlertController(title: "Guess letter", message: "Introduce a letter", preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else{ return }
            self?.guessWord(answer)
            
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func guessWord(_ answer: String) {
        if word.contains(answer) {
            guess.append(answer)
        }
        return
        
    }
    
    

}

