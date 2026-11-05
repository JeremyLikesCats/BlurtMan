//
//  BlurtManApp.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 2/11/2026.
//

import SwiftUI

@main
struct BlurtManApp: App {
    @State private var blurtItems = BlurtItemStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(blurtItems)
        }
        #if os(macOS)
        Settings {
            SettingsView()
                .environment(blurtItems)
        }
        #endif
    }
    init() {
        UserDefaults.standard.register(defaults: [
            "dateIntervals": "1, 3, 7, 14, 30"
        ])
        blurtItems.setDates()
    }
}

