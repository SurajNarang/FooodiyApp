//
//  ContentView.swift
//  Fooodify
//
//  Created by Group 5 on 3/7/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var prefList: Food
    //@Binding var isShowing: Bool
    @State private var selectedTab = 0
    @State private var doAddCuisine: Bool = false
    @State private var cuisine: String = String()
    @State private var location: String = String()


    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreen().tabItem {
                Image(systemName: "info.circle")
                Text("About")
                    .padding()
            }.tag(0)
            HomeView().environmentObject(prefList).tabItem {
                Image(systemName: "house")
                Text("Home")
                    .padding()
            }.tag(1)
            NewView().environmentObject(prefList).tabItem {
                Image(systemName: "globe")
                Text("Location")
                    .padding()
            }.tag(2)
        }
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    @State private var doAddCuisine: Bool = false

    static var previews: some View {
        ContentView().environmentObject(Food())
    }
}*/
