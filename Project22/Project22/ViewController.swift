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
        //Did we get authorized by the user?
        if status == .authorizedAlways {
            //Is our device able to monitor iBeacons?
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                //Is ranging available? (Ranging is the ability to tell roughly how far something else is away from our device.)
                if CLLocationManager.isRangingAvailable() {
                    startScannig()
                }
            }
        }
    }
    
    func startScannig() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        //UUID, major and minor are all identifiers to know the precise location of the beacon, for example, if your flagship London(uuid) store has 12 floors(major) each of which has 10 departments(minor).
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        //This is not our method above
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "IMMEDIATE"
            //Because CLProximity is an enum that might change in future updates(like adding a veryFar value), this @unknown default is to specifically catch future values
            @unknown default:
                self.view.backgroundColor = .black
                self.distanceReading.text = "WHOA"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
}

