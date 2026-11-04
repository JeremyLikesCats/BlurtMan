//
//  TabView.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 3/11/2026.
//

import SwiftUI
struct ContentView: View {
    @State private var selectedTab = 0
    @Environment(BlurtItemStore.self) private var blurtItems
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: 0) {
                MainView()
                    .environment(blurtItems)
            }
            
            Tab("Schedule", systemImage: "calendar", value: 1) {
                CalendarView()
                    .environment(blurtItems)
            }
            
        }
        #if os(iOS)
        .tabViewStyle(.page(indexDisplayMode: .never))
        
        #endif

    }
}

#Preview {
    ContentView()
        .environment(BlurtItemStore())
}

