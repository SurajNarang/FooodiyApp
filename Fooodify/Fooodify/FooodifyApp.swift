//
//  FooodifyApp.swift
//  Fooodify
//
//  Created by Group 5 on 3/7/22.
//

import SwiftUI

@main
struct FooodifyApp: App {
    @StateObject var prefList: Food = Food()
    //@State private var doAddCuisine: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView(/*isShowing: $doAddCuisine*/).environmentObject(prefList)
        }
    }
}
