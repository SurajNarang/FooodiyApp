//
//  Home.swift
//  Fooodify
//
//  Created by Sahil Sinha on 3/17/22.
//

import SwiftUI

struct Home: View {
    
    @StateObject var HomeModel = HomeViewModel()
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                HStack(spacing: 15) {
                    Button(action: {}, label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(Color("pink"))
                    })
                    
                    Text(HomeModel.userLocation == nil ? "Locating..." : "Deliver To")
                        .foregroundColor(.black)
                    
                    Text(HomeModel.userAddress)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(Color("pink"))
                    
                    Spacer(minLength: 0)
                    
                }.padding([.horizontal,.top])
                
                Divider()
                
                HStack(spacing: 15) {
                    TextField("Search", text: $HomeModel.search)
                    if HomeModel.search != "" {
                        Button(action: {}, label: {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }).animation(.easeIn)
                    }
                }.padding(.horizontal)
                    .padding(.top, 10)
                
                Divider()
                
                Spacer()
            }
            
            // Side Menu
            
            
            if HomeModel.noLocation {
                Text ("Please enable location access in settings to proceed to more Fooodify features!")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
        }
        
        .onAppear(perform: {
            
            // Calls location delegate
            HomeModel.locationManager.delegate = HomeModel
            HomeModel.locationManager.requestWhenInUseAuthorization()
            // Modifying info.plist
        })
    }
}
