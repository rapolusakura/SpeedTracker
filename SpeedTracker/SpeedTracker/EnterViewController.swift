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

class EnterViewController: UIViewController {
        let locationManager = CLLocationManager()
        var startedTrip: Bool = false
        var path =  [Coordinate]()
        var location: CLLocation!
        
        @IBOutlet weak var startTripButtonLabel: UIButton!
        
        @IBAction func startTripButtonPressed(_ sender: UIButton) {
            if startedTrip {
                startedTrip = false
                locationManager.stopUpdatingLocation()
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
            // Do any additional setup after loading the view, typically from a nib.
            locationManager.delegate = self
            if NSString(string:UIDevice.current.systemVersion).doubleValue > 8 {
                locationManager.requestAlwaysAuthorization()
            }
            locationManager.desiredAccuracy=kCLLocationAccuracyBest
            location = locationManager.location
            
            let parameters = ["key":Constants.apiKey,"path":"37.7771755,-122.4271653", "interpolate":"true"]
            
            Alamofire.request("https://roads.googleapis.com/v1/snapToRoads?", parameters: parameters).responseJSON(options:.mutableContainers) {JSON in
                print(JSON)
            }
            
            path.append(Coordinate(lat: location.coordinate.latitude, long: location.coordinate.longitude))
            
            speedLabel.text = String("latitude: \(location.coordinate.latitude) longitude: \(location.coordinate.longitude)")
            print(String("latitude: \(location.coordinate.latitude) longitude: \(location.coordinate.longitude)"))
        }

        @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
            
        }

}

extension EnterViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var speed: CLLocationSpeed
        speed = (locationManager.location?.speed)!
        speedLabel.text = String(format: "%.2f", speed)
        location = locationManager.location
        path.append(Coordinate(lat: location.coordinate.latitude, long: location.coordinate.longitude))
        print(String("latitude: \(location.coordinate.latitude) longitude: \(location.coordinate.longitude)"))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.denied{
            locationManager.startUpdatingLocation()
        }
    }
}

