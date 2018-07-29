//
//  ViewController.swift
//  SpeedTracker
//
//  Created by Sakura Rapolu on 7/24/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//
import UIKit
import Alamofire
import CoreLocation
import CoreMotion

class EnterViewController: UIViewController {
        let motionManager = CMMotionManager()
        let locationManager = CLLocationManager()
        var startedTrip: Bool = false
        var path =  [Coordinate]()
        var location: CLLocation!
        var speed: CLLocationSpeed!
        var acceleration: CMAcceleration!
        let speedLimit: Double = 1
        var count: Double = 0
        
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var startTripButtonLabel: UIButton!
        
        @IBAction func startTripButtonPressed(_ sender: UIButton) {
            if startedTrip {
                startedTrip = false
                locationManager.stopUpdatingLocation()
                motionManager.stopAccelerometerUpdates()
                sender.setTitle("Start Trip", for: UIControlState.normal)
                self.performSegue(withIdentifier: "displayStats", sender: self)
            } else {
                startedTrip = true
                //start a function to start getting the speed limit and check if current speed > speed limit, if so record the time interval and the speed limit during that interval, and the avg speed (short segments??) of the user 
                sender.setTitle("End Trip", for: UIControlState.normal)
            }
        }
        
        @IBOutlet weak var speedLabel: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            // Do any additional setup after loading the view, typically from a nib.
            view.backgroundColor = .green
            //gets initial location
            location = locationManager.location
            print(location.coordinate.longitude)
            print(location.coordinate.latitude)
        }

        @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
            
        }
}

extension EnterViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location: \(location)")
        }
        
        acceleration = motionManager.accelerometerData?.acceleration
        speed = (locationManager.location?.speed)!
        count = count + 1
        speedLabel.text = String(format: "%.2f", speed)
        if isSpeeding(currSpeed: speed, speedLimit: speedLimit) {
            view.backgroundColor = .red
            view.reloadInputViews()
        } else {
            view.backgroundColor = .green
            view.reloadInputViews()
        }
        countLabel.text = String(count)
        location = locationManager.location
        path.append(Coordinate(lat: location.coordinate.latitude, long:         location.coordinate.longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.denied{
            locationManager.requestLocation()
            locationManager.distanceFilter = 1
            locationManager.startUpdatingLocation()
            motionManager.accelerometerUpdateInterval = 0.5
            motionManager.startAccelerometerUpdates()
        }
    }
    
    func isSpeeding(currSpeed: Double, speedLimit: Double) -> Bool {
        return currSpeed > speedLimit
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}


