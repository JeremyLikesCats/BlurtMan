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
    @State private var calendarModel = CalendarModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(blurtItems)
                .environment(calendarModel)
                .task {
                    await calendarModel.setup()
                    blurtItems.resetCalendar(calendarModel: calendarModel)
                }
        }
        #if os(macOS)
        Settings {
            SettingsView()
                .environment(blurtItems)
                .environment(calendarModel)
        }
        #endif
    }
    init() {
        UserDefaults.standard.register(defaults: [
            "dateIntervals": "1, 3, 7, 14, 30",
            "calendarSpecifyTime": false,
            "calendarAlertTime": "19:00",
            "calendarStartTime": "19:00",
            "calendarEndTime": "20:00"
        ])
    }
}

