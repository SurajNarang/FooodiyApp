//
//  NewView.swift
//  Fooodify
//
//  Created by Group 5 on 4/3/22.
//

import SwiftUI
import MapKit
import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    // Location details
    @Published var userLocation : CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // checks Location access
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("denied")
            self.noLocation = true
        default:
            print("unknown")
            self.noLocation = false
        }
    }
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
}
extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
}
extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) {
            completion($0?.first?.locality, $0?.first?.country, $1)
        }
    }
}

struct YelpView: View {
    @State private var city1 = String()
    @State private var country1 = String()
    @State private var search = false
    @State private var selected = false
    @State private var doAddCuisine: Bool = false
    @State private var cuisine: String = String()
    @State private var location: String = String()
    @EnvironmentObject private var prefList: Food
    @EnvironmentObject private var locationManager: LocationManager
    
    var body: some View {
        VStack {
            HStack {
                Text("Type of Cuisine: ")
                TextField("Mediterranean, Mexican, etc.", text: $cuisine) {}
            }.padding()
        }
        HStack {
            Text("Location: ")
            TextField("College Park, United States", text: $location) {}
        }.padding()
            .disabled(selected)
        Button("Search") {
            search = true
        }
            .help(Text("Format: City Name, Country"))
        Toggle("Use Current Location", isOn: $selected)
            .padding()
            .onChange(of: selected) { _ in
                search = false
                locationManager.location?.fetchCityAndCountry { city, country, error in
                    guard let city = city, let country = country, error == nil else { return }
                    city1 = city
                    country1 = country
                }
            }
        
        /*------------ Print YELP Results ------------*/
        VStack {
            // Use Current Location and Display Yelp Results
            if selected {
                HStack {
                    if city1 != "" && country1 != "" {
                        Text("Showing results for: \(city1), \(country1)")
                    }
                }
                let coord = locationManager.location?.coordinate
                let lat = coord?.latitude ?? 0
                let lon = coord?.longitude ?? 0
                let list = prefList.venList(latitude: lat, longitude: lon)
                List(list.startIndex..<list.count, id:\.self) { i in
                    let name = String(list[i].name ?? "Test")
                    let rating = String(list[i].rating ?? 0.0)
                    let price = String(list[i].price ?? "N/A")
                    let phone = String(list[i].phone ?? "N/A")
                    let distance = String(format: "%.2f", (list[i].distance ?? 0.0 * 0.000621))
                    let address = String(list[i].address ?? "N/A")
                    let link = String(list[i].url ?? "")
                    let url = URL(string: link)
                    let string = "Name: " + name + "\nStatus: " + rating + "\nPrice: " + price + "\nPhone: " + phone + "\nDistance: " + distance + "miles\nAddress: " + address
                    Text(string)
                        .padding()
                        .onTapGesture {
                            if link != "" {
                                UIApplication.shared.open(url!)
                            }
                        }
                }
            }
            else if search { // Use location city name passed in
                HStack {
                    if location != "" {
                        Text("Showing results for: \(location)")
                    }
                }
                let loc = prefList.getCoordinate(location: location)
                let list = prefList.venList(latitude: loc.latitude, longitude: loc.longitude)
                List(list.startIndex..<list.count, id:\.self) { i in
                    let name = String(list[i].name ?? "Test")
                    let rating = String(list[i].rating ?? 0.0)
                    let price = String(list[i].price ?? "N/A")
                    let phone = String(list[i].phone ?? "N/A")
                    let distance = String(format: "%.2f", (list[i].distance ?? 0.0 * 0.000621))
                    let address = String(list[i].address ?? "N/A")
                    let link = String(list[i].url ?? "")
                    let url = URL(string: link)
                    let string = "Name: " + name + "\nStatus: " + rating + "\nPrice: " + price + "\nPhone: " + phone + "\nDistance: " + distance + "miles\nAddress: " + address
                    Text(string)
                        .padding()
                        .onTapGesture {
                            if link != "" {
                                UIApplication.shared.open(url!)
                            }
                        }
                }
            }
        }
    }
}

struct NewView: View {
    @EnvironmentObject private var prefList: Food
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Fooodify")
                .padding()
                .font(.title)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
            YelpView().environmentObject(prefList).environmentObject(LocationManager())

        }
    }
}
