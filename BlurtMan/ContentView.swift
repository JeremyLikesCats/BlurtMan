//
//  TabView.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 3/11/2026.
//

import SwiftUI
struct ContentView: View {
    #if os(macOS)
    @State private var selectedTab = 0
    #endif
    #if os(iOS)
    @State private var selectedTab = 1
    #endif
    @Environment(BlurtItemStore.self) private var blurtItems
    @Environment(CalendarModel.self) private var calendarModel
    
    var body: some View {
        TabView(selection: $selectedTab) {
            #if os(macOS)
            Tab("Home", systemImage: "house", value: 0) {
                MainView()
                    .environment(blurtItems)
                    .environment(calendarModel)
            }
            
            Tab("Schedule", systemImage: "calendar", value: 1) {
                CalendarView()
                    .environment(blurtItems)
                    .environment(calendarModel)
            }
            #endif
            
            #if os(iOS)
            Tab("Settings", systemImage: "gearshape", value: 0) {
                SettingsView()
                    .environment(blurtItems)
                    .environment(calendarModel)
            }

            Tab("Home", systemImage: "house", value: 1) {
                MainView()
                    .environment(blurtItems)
                    .environment(calendarModel)
            }
            
            Tab("Schedule", systemImage: "calendar", value: 2) {
                CalendarView()
                    .environment(blurtItems)
                    .environment(calendarModel)
            }
            
            #endif
            
        }
        #if os(iOS)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        #endif

    }
}

#Preview {
    ContentView()
        .environment(BlurtItemStore())
        .environment(CalendarModel())
}

