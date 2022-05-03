//
//  model.swift
//  Fooodify
//
//  Created by Group 5 on 3/7/22.
//

import Foundation
import CoreLocation

struct Preferences: Hashable, Codable {
    var typeOfCuisine: String
    var location: String
}

class Food: ObservableObject {
    @Published private var _list: [Preferences]
    @Published var restaurant: [Restaurant] = []
    @Published var loc = CLLocationCoordinate2D()

    
    init() {
        _list = []
    }
    
    func addPref(pref:Preferences) {
        _list.append(pref)
    }
    
    func delPref(_ index:Int) {
        if (_list.startIndex..<_list.count).contains(index) {
            _list.remove(at: index)
        }
    }
    
    func list() -> [Preferences] {
        return _list
    }
    
    func venList(latitude: Double, longitude: Double) -> [Restaurant] {
        //print(latitude, longitude)
        retrieveVenues(latitude: latitude, longitude: longitude, category: "food", limit: 3, sortBy: "distance", locale: "en_US") { (response, error) in
            if let response = response {
                DispatchQueue.main.async {
                    self.restaurant = response
                }
            }
        }
        return restaurant
    }
    
    // Translates City Name to a Coordinate
    func getCoordinate(location: String) -> CLLocationCoordinate2D {
        let locationManager = LocationManager()
        locationManager.getCoordinateFrom(address: location) { coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            DispatchQueue.main.async {
                self.loc = coordinate
            }
        }
        return loc
    }
}
