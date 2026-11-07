//
//  BlurtManApp.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 2/11/2026.
//

// TODO: Ensure user can only input blurt of a unique title
// TODO: Ensure user's inputted blurt schedule cannot exceed 200 days.

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
        
    }
}

