//
//  FetchData.swift
//  Fooodify
//
//  Created by Group 5 on 4/17/22.
//

import Foundation
import UIKit

struct Restaurant: Codable, Identifiable {
    var name: String?
    var id: String?
    var rating: Float?
    var price: String?
    var distance: Double?
    var phone: String?
    var address: String?
    var url: String?
}

//extension UIViewController {
func retrieveVenues(latitude: Double, longitude: Double, category: String, limit: Int, sortBy: String, locale: String, completionHandler: @escaping ([Restaurant]?, Error?) -> Void) {
    let apiKey = "o0WaMrx9fHGkafDrIiJHPrihZya3feH06Q2YAf3mMdpWIoEHBOwIkmwAfHOMzPyKXs8iW7foQ-4Oo94Pqm-vRFE6pzZApcmoF4hB8_PBq3x1hSVHJES41GlndSNmYnYx"
    
    let baseURL = "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&limit=\(limit)&categories=\(category)&sort_by=\(sortBy)&locale=\(locale)"
    
    // Create URL
    let url = URL(string: baseURL)
    
    // Create Requests
    var request = URLRequest(url: url!)
    request.setValue ("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"
    
    // Initialize Session and Task
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completionHandler(nil, error)
        }
        do {
            // Read JSON Data
            let json = try JSONSerialization.jsonObject(with: data!, options: [])
            print(json)
            
            // Main dictionary
            guard let dictionary = json as? NSDictionary else { return }

            // Business
            guard let businesses = dictionary.value(forKey: "businesses") as? [NSDictionary] else { return }
            
            var venuesList: [Restaurant] = []
            
            for business in businesses {
                var restaurant = Restaurant()
                restaurant.name = business.value(forKey: "name") as? String
                restaurant.id = business.value(forKey: "id") as? String
                restaurant.rating = business.value(forKey: "rating") as? Float
                restaurant.price = business.value(forKey: "price") as? String
                restaurant.distance = business.value(forKey: "distance") as? Double
                restaurant.phone = business.value(forKey: "display_phone") as? String
                guard let temp = business.value(forKey: "location") as? NSDictionary else { return }
                let temp2 = temp.value(forKey: "display_address") as? [String?]
                restaurant.address = (temp2?[0] ?? "") + "\n" + (temp2?[1] ?? "")!
                restaurant.url = business.value(forKey: "url") as? String
                venuesList.append(restaurant)
            }
            completionHandler(venuesList, nil)
        }
        catch {
            print("Error in retrieving venues")
        }
    }.resume()

}
