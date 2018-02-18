//
//  Location.swift
//  Photoviewer
//
//  Created by Tomoya Matsuyama on 2018/02/17.
//  Copyright © 2018年 Tomoya Matsuyama. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

struct Position {
    var latitude: String
    var longtitude: String
}

class Location {
    static func geoCoder(text: String, completion: ((Position) -> Void)? = nil) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = text
        let localSearch:MKLocalSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler: { (result, error) in
            guard let result = result else { return }
            for placemark in result.mapItems {
                if error == nil {
                    completion?(Position.init(latitude: "\(placemark.placemark.coordinate.latitude)", longtitude: "\(placemark.placemark.coordinate.longitude)"))
                } else {
                    fatalError("error")
                }
            }
        })
    }
    
    static func reverseGeoCoder(lat: Double, log: Double, completion: ((String) -> Void)? = nil) {
        let location = CLLocation(latitude: lat, longitude: log)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (places, error) -> Void in
            if error == nil {
                guard let places = places else { return }
                guard let place = places.first else { return }
                if let city = place.locality, let country = place.country {
                    completion?(city + ", " + country)
                }
            }
        })
    }
}
