//
//  SettingsView.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 4/11/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(BlurtItemStore.self) private var blurtItems
    @Environment(CalendarModel.self) private var calendarModel
    @AppStorage("dateIntervals") private var dateIntervals: String = "1, 3, 7, 14, 30"
    @AppStorage("calendarSpecifyTime") private var specifyTime: Bool = false
    @AppStorage("calendarAlertTime") private var alertTime: String = "19:00"
    @AppStorage("calendarStartTime") private var startTime: String = "19:00"
    @AppStorage("calendarEndTime") private var endTime: String = "20:00"
    
    @State var showingDeleteAlert = false
    @State var itemToDelete: BlurtItem?
    
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
                            blurtItems.resetCalendar(calendarModel: calendarModel)
                        }
                }
                
                Section("Calendar Integration") {
                    Toggle("Specify Blurt Timing", isOn: $specifyTime)
                        .onChange(of: specifyTime) {
                            blurtItems.resetCalendar(calendarModel: calendarModel)
                        }
                    if specifyTime {
                        DatePicker("Calendar Start Time", selection: dateBinding(string: $startTime, defaultValue: "19:00"), displayedComponents: .hourAndMinute)
                            .onChange(of: startTime) {
                                blurtItems.resetCalendar(calendarModel: calendarModel)
                            }
                        DatePicker("Calendar End Time", selection: dateBinding(string: $endTime, defaultValue: "20:00"), displayedComponents: .hourAndMinute)
                            .onChange(of: endTime) {
                                blurtItems.resetCalendar(calendarModel: calendarModel)
                            }
                    } else {
                        DatePicker("Calendar Alert Time", selection: dateBinding(string: $alertTime, defaultValue: "19:00"), displayedComponents: .hourAndMinute)
                            .onChange(of: alertTime) {
                                blurtItems.resetCalendar(calendarModel: calendarModel)
                            }
                    }
                }
                
                Section("Manage Subjects") {
                    List {
                        ForEach(blurtItems.items) { blurtItem in
                            HStack {
                                Circle()
                                    .fill(blurtItem.color)
                                    .frame(width: 24, height: 24)
                                Text(blurtItem.title)
                                Spacer()
                                Button() {
                                    itemToDelete = blurtItem
                                    showingDeleteAlert = true
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundStyle(.red)
                                        .font(.title2)
                                        .buttonStyle(.borderless)
                                }
                            }
                        }
                    }
                    .alert("Delete Subject?", isPresented: $showingDeleteAlert) {
                        Button("Delete", role: .destructive) {
                            if let itemToDelete {
                                withAnimation {
                                    blurtItems.removeItem(itemToDelete, calendarModel: calendarModel)
                                }
                            }
                            itemToDelete = nil
                        }
                        Button("Cancel", role: .cancel) {
                            itemToDelete = nil
                            showingDeleteAlert = false
                        }
                    } message: {
                        Text("Are you sure you want to delete \"\(itemToDelete?.title ?? "")\" and remove its calendar events?")
                    }
                    
                    
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
