//
//  RemindersIntegration.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 7/11/2026.
//

import EventKit
public import Combine

// i used https://www.createwithswift.com/creating-reminder-lists-with-eventkit-from-your-app/ to learn initially lol

// Essetially the program should create a calendar of its own, then add the blurt schedules for each subject that are customizable (by default 7pm-8pm).


@MainActor
class CalendarModel: ObservableObject {
    private let eventStore = EKEventStore()
    @Published var calendar: EKCalendar?
    
    private let calendarUserdefaultsKey = "blurtManCalendar"
    private let calendarTitle = "BlurtMan"
    
    
    func setup() async {
        do {
            let granted = try await eventStore.requestWriteOnlyAccessToEvents()
            guard granted else {return}
            calendar = try loadAppCalendar()
        } catch {
            print("Reminders access error:", error.localizedDescription)
        }
        
    }
    
    func loadAppCalendar() throws -> EKCalendar {
        if let id = UserDefaults.standard.string(forKey: calendarUserdefaultsKey),
            let existing = eventStore.calendar(withIdentifier: id) {
            return existing
        }
        
        // Otherwise search by name
        if let existing = eventStore.calendars(for: .event).first(where: { $0.title == calendarTitle }) {
            UserDefaults.standard.set(existing.calendarIdentifier, forKey: calendarUserdefaultsKey)
        }
        
        // Otherwise create the calendar
        let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        newCalendar.title = calendarTitle
        guard let source = eventStore.defaultCalendarForNewEvents?.source ?? eventStore.sources.first(where: { $0.sourceType == .local || $0.sourceType == .calDAV }) else {
                throw NSError(domain: "Calendar", code: 1, userInfo: [NSLocalizedDescriptionKey: "No valid source for Calendars"])
            }

        newCalendar.source = source
        try eventStore.saveCalendar(newCalendar, commit: true)
        
        UserDefaults.standard.set(newCalendar.calendarIdentifier, forKey: calendarUserdefaultsKey)
        return newCalendar
    }

    
    func clearCalendarBasedOnEventName(title: String) throws {
        guard let currentCalendar = calendar else { return }
        
        let start = Calendar.current.startOfDay(for: .now)
        guard let end = Calendar.current.date(byAdding: .year, value: 1, to: start) else {return}
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: [currentCalendar])
        let events = eventStore.events(matching: predicate).filter { $0.title == title }
        
        for event in events {
            try eventStore.remove(event, span: .thisEvent, commit: false)
        }
        
        try eventStore.commit()
    }
}



