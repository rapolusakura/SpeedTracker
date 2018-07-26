//
//  Coordinate.swift
//  SpeedTracker
//
//  Created by Sakura Rapolu on 7/26/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit

struct Coordinate {
    let latitude: Double
    let longitude: Double
    
    init(lat: Double, long: Double) {
        self.latitude = lat
        self.longitude = long
    }
}
