//
//  ViewController.swift
//  SpeedTracker
//
//  Created by Sakura Rapolu on 7/24/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//
import UIKit
import CoreLocation

    class ViewController: UIViewController, CLLocationManagerDelegate {
        let locationManager = CLLocationManager()
        
        @IBOutlet weak var speedLabel: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            locationManager.delegate = self
            if NSString(string:UIDevice.current.systemVersion).doubleValue > 8 {
                locationManager.requestAlwaysAuthorization()
            }
            locationManager.desiredAccuracy=kCLLocationAccuracyBest
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            var speed: CLLocationSpeed = CLLocationSpeed()
            speed = (locationManager.location?.speed)!
            speedLabel.text = String(speed)
        }
    
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status != CLAuthorizationStatus.denied{
                locationManager.startUpdatingLocation()
            }
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

