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

    var body: some Scene {
        WindowGroup {
            Starter()
        }
        .modelContainer(for:Welcome.self)
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
