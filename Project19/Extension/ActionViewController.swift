//
//  ActionViewController.swift
//  Extension
//
//  Created by Ayax Alexis Casarrubias Rodríguez on 13/01/20.
//  Copyright © 2020 Ayax Alexis. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // This code is similar to Apple's template but easier to undestand, better use Apple's
        //extensionContext let us control how it interacts with the parent app
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                //Ask the item provider to actually provide us with its item, but you'll notice it uses a closure so this code executes asynchronously. 
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    //do stuff
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
