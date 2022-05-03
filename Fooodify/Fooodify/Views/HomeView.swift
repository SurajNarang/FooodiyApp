//
//  HomeView.swift
//  Fooodify
//
//  Created by Group 5 on 4/3/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var prefList: Food
    @State private var doAddCuisine: Bool = false
    @State private var cuisine: String = String()
    @State private var location: String = String()
    @State private var removeAlert: Bool = false
    @State private var removing: Int? = nil

    var body: some View {
        VStack(alignment: .center) {
            Text("Fooodify")
                .padding()
                .font(.title)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
            VStack {
                HStack {
                    Text("Type of Cuisine: ")
                    TextField("Mediterranean, Mexican, etc.", text: $cuisine) {}
                }.padding()
            }
            HStack {
                Text("Location: ")
                TextField("City Name Only ex: College Park", text: $location) {}
            }.padding()
            Button("Add Preference") {
                if cuisine != "" && location != "" {
                    let food = Preferences(typeOfCuisine: cuisine, location: location)
                    prefList.addPref(pref: food)
                    cuisine = String()
                    location = String()
                    doAddCuisine = false
                }
            }.padding()
            Spacer()
            
            HStack {
                VStack {
                    List(prefList.list().startIndex..<prefList.list().count, id: \.self) {i in
                        let pref = prefList.list()[i]
                        let string = "Cuisine: " + pref.typeOfCuisine + "\nLocation: " + pref.location
                        Text(string)
                            .font(.title2)
                            .foregroundColor(.black)
                            .onLongPressGesture {
                                removing = i
                                removeAlert = true
                            }
                    }
                    .alert(isPresented: $removeAlert) {
                        Alert(
                            title: Text("Confirm Deletion"),
                            message:
                                Text("Do you really want to delete \(prefList.list()[removing!].typeOfCuisine)?"),
                            primaryButton:
                                    .destructive(Text("Delete")) {
                                        prefList.delPref(removing!)
                                        removing = nil
                                    },
                            secondaryButton: .cancel() {
                                removing = nil
                            }
                        )
                    }
                }
            }
        }
    }
}
