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
    @AppStorage("calendarStartTime") private var startTime: String = ""
    @AppStorage("calendarEndTime") private var endTime: String = ""
    
    private func dateBinding(string: Binding<String>, defaultValue: String) -> Binding<Date> {
        Binding(
            get: {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "HH:mm"
                return formatter.date(from: string.wrappedValue) ?? formatter.date(from: defaultValue)!
            },
            set: {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "HH:mm"
                string.wrappedValue = formatter.string(from: $0)
            }
        )
    }
    
    var body: some View {
        VStack {
            Form {
                Section("Blurt Intervals") {
                    TextField("Enter a range of days here, e.g. 1, 3, 5, 7, 9", text: $dateIntervals)
                        .onChange(of: dateIntervals) { oldValue, newValue in
                            blurtItems.setDates()
                        }
                }
                
                
                
                Section("Calendar Integration") {
                    DatePicker("Calendar Start Time", selection: dateBinding(string: $startTime, defaultValue: "19:00"), displayedComponents: .hourAndMinute)
                    DatePicker("Calendar End Time", selection: dateBinding(string: $endTime, defaultValue: "10:00"), displayedComponents: .hourAndMinute)
                    
                }
                
                Button("Reset All Settings", role: .destructive) {
                    if let bundleID = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bundleID)
                    }
                    blurtItems.setDates()
                }
                
            }
            
        }
        

    }
}
#Preview {
    SettingsView()
        .environment(BlurtItemStore())
}
