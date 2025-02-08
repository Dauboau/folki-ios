//
//  FolkiApp.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 05/02/25.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct FolkiApp: App {

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
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
            Hub()
        }
        .modelContainer(sharedModelContainer)
    }
    
    init() {
        do {
            try Tips.configure([
                .displayFrequency(.hourly)
            ])
        }
        catch {
            print("Error initializing tips: \(error)")
        }
    }
    
}
