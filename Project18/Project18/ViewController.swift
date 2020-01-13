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
        
        assert(1 == 1, "Maths failure!")
        //It receives two parameters, something to check and a message to print if the check fails.
        assert(myReallySlowMethod() == true, "The slow method returned false, which is a bad thing!")
        
        //Breackpoints
        
        for i in 1...100 {
            //Xcode will pause the execution of code at the breackpoint and show the value of all your variables
            print("Number is \(i)") //The window in the right shows the threads and who call who
            //In the console you can write p i to print the current value of i
            //We can also make breackpoints conditionals with Edit Breakpoint
            
            //We can also trigger breackpoint when an Exception is thrown, o make this happen, press Cmd+8 to choose the breakpoint navigator – it's on the left of your screen, where the project navigator normally sits. Now click the + button in the bottom-left corner and choose "Exception Breakpoint."
        }
    }
    
    
    func myReallySlowMethod() -> Bool{
        //method
        return true
    }


}

