//
//  ViewController.swift
//  Project22
//
//  Created by Ayax Alexis Casarrubias Rodríguez on 18/01/20.
//  Copyright © 2020 Ayax Alexis. All rights reserved.
//

import UIKit
//Core Location class lets us configure how we want to be notified about location, and will also deliver location updates to us.
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?

    @IBOutlet var distanceReading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        //As the delegate is us, the method locationManager will be called
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //Did we get authorized by the user? If so, is our device able to monitor iBeacons? If so, is ranging available? (Ranging is the ability to tell roughly how far something else is away from our device.)
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    //do stuff
                }
            }
        }
    }
}

