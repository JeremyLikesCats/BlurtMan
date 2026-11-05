//
//  SettingsView.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 4/11/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(BlurtItemStore.self) private var blurtItems
    @AppStorage("dateIntervals") private var dateIntervals: String = "1, 3, 7, 14, 30"
    var body: some View {
        Form {
            Section("Blurt Intervals") {
                TextField("Enter a range of days here, e.g. 1, 3, 5, 7, 9", text: $dateIntervals)
                    .onChange(of: dateIntervals) { oldValue, newValue in
                        blurtItems.setDates()
                    }
            }
            
        }
        Button("Reset All Settings", role: .destructive) {
            if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
            }
            blurtItems.setDates()
        }

    }
    init() {
        
    }
}
