//
//  sheepyApp.swift
//  sheepy
//
//  Created by Isabela Bastos Jastrombek on 24/11/24.
//

import SwiftUI
import SwiftData

@main
struct sheepyApp: App {
    @State private var showSplash = true
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Dream.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else {
                DreamListView()
                    .preferredColorScheme(.dark)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
