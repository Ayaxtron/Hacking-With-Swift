//
//  ViewController.swift
//  Project18
//
//  Created by Ayax Alexis Casarrubias Rodríguez on 12/01/20.
//  Copyright © 2020 Ayax Alexis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Separator let's us put a string between the every item in the print() call
        print(1, 2, 3, 4, 5, separator: "-")
        
        //Temrinator is what should be placed after the final item, by default it's \n
        print(1, 2, 3, 4, 5, terminator: "")
        
        
        //Assertions
        
        //Assertions are debug-only checks (they will only execute while debugging, and Xcode will disable them whem the app is released) that will force the app to crash if a specific condition isn´t true.
        
        assert(1 == 2, "Maths failure!")
        //It receives two parameters, something to check and a message to print if the check fails.
        assert(myReallySlowMethod() == true, "The slow method returned false, which is a bad thing!")
    }
    
    
    func myReallySlowMethod() -> Bool{
        //method
        return true
    }


}

