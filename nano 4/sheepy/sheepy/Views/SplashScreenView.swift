//
//  SplashScreenView.swift
//  sheepy
//
//  Created by Isabela Bastos Jastrombek on 25/11/24.
//

import Foundation
import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("DarkBlue"), Color("LightBlue")]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            Image("LogoName")
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .foregroundColor(.white)
        }
    }
}
