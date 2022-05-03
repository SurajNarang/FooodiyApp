//
//  HomeScreen.swift
//  Fooodify
//
//  Created by Group 5 on 4/12/22.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        ZStack {
            VStack{
                VStack{
                    Text("  Welcome To Fooodify").font(.system(size: 50)).bold().position(x: 200, y: 325)
                    Text("Where your cravings are met in a moments notice!").frame(width: 250, height: 200, alignment: .leading)
                        .multilineTextAlignment(.center).position(x: 200, y: 70).font(.subheadline)
                }
            }
        }.background(
            Image("Food")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            )
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
