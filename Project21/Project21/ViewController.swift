//
//  ViewController.swift
//  Project21
//
//  Created by Ayax Alexis Casarrubias Rodríguez on 18/01/20.
//  Copyright © 2020 Ayax Alexis. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UINavigationControllerDelegate, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    //To ask permission to send notifications
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay")
            } else {
                print("D'oh")
            }
        }
    }
    
    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "Im too lazy to copy everything here"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        //This is for Calendar Notifications
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
       let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        //Its has a unique identifier(using UUID), the content and the trigger
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        //The delegate is self so that any alert-based messages get routed to our viewController to be handled
        let center = UNUserNotificationCenter.current()
        //As we arenow the delegate, we decide how to handle the notification
        center.delegate = self
        //NotificationAction creates an individual button
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        //NotificationCategory groups multiple buttons under a single identifier
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data receiver \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                //The user swipped to unlock
                print("Default Identifier")
            case "show":
                //The user tapped our "show more info..." button
                print("Show more info...")
                
            default:
                break
            }
        }
    }
}

