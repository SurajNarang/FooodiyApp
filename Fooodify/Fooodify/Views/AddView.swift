//
//  AddView.swift
//  Fooodify
//
//  Created by Group 5 on 3/31/22.
//

import Foundation
import SwiftUI

struct AddView: View {
    @EnvironmentObject private var prefList: Food
    @Binding var isShowing: Bool
    @State private var doAddCuisine: Bool = false
    @State private var cuisine: String = String()
    @State private var location: String = String()


    var body: some View {
        VStack {
            HStack {
                Text("Type of Cuisine: ")
                TextField("Mediterranean, Mexican, etc.", text: $cuisine) {}
            }.padding()
        }
        HStack {
            Text("Location: ")
            TextField("", text: $location) {}
        }.padding()
        Button("Add Preference") {
            let food = Preferences(typeOfCuisine: cuisine, location: location)
            prefList.addPref(pref: food)
            isShowing = false
            cuisine = String()
            location = String()
            doAddCuisine = false
        }.padding()
    }
}
