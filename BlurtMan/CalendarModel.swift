//
//  RemindersIntegration.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 7/11/2026.
//

import EventKit
import Combine

// i used https://www.createwithswift.com/creating-reminder-lists-with-eventkit-from-your-app/ to learn initially lol

// Essetially the program should create a calendar of its own, then add the blurt schedules for each subject that are customizable (by default 7pm-8pm).


@MainActor
@Observable
class CalendarModel {
    private let eventStore = EKEventStore()
    var calendar: EKCalendar?
    
    private let calendarUserdefaultsKey = "blurtManCalendar"
    private let calendarTitle = "BlurtMan"
    
    
    func setup() async {
        do {
            let granted = try await eventStore.requestFullAccessToEvents()
            guard granted else {return}
            calendar = try loadAppCalendar()
            
        } catch {
            print("Calendar access error:", error.localizedDescription)
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
            return existing
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

    func updateCalendarForItem(item: BlurtItem, allDayAlertTime: String) throws {
        // ALL DAY VERSION
        
        try clearCalendarBasedOnItemName(title: item.title)
        let datesToUpdate = item.dates
        for dateToUpdate in datesToUpdate {
            let newEvent = EKEvent(eventStore: eventStore)
            newEvent.title = item.title
            newEvent.calendar = calendar
            newEvent.isAllDay = true
            newEvent.startDate = Calendar.current.startOfDay(for: dateToUpdate)
            newEvent.endDate = newEvent.startDate
            newEvent.addAlarm(EKAlarm(relativeOffset: getTimeInterval(from: allDayAlertTime)))
            try eventStore.save(newEvent, span: .thisEvent, commit: false)
        }
        try eventStore.commit()
    }
    
    func updateCalendarForItem(item: BlurtItem, startTime: String, endTime: String) throws {
        // NON ALL DAY VERSION
        try clearCalendarBasedOnItemName(title: item.title)
        let datesToUpdate = item.dates
        for dateToUpdate in datesToUpdate {
            let newEvent = EKEvent(eventStore: eventStore)
            newEvent.title = item.title
            newEvent.calendar = calendar
            newEvent.isAllDay = false
            
            let start = getDateFromTime(time: startTime, day: dateToUpdate)
            var end = getDateFromTime(time: endTime, day: dateToUpdate)
            
            if let start, let e = end, e < start {
                end = Calendar.current.date(byAdding: .hour, value: 1, to: start)
            }
            
            newEvent.startDate = start
            newEvent.endDate = end
            
            try eventStore.save(newEvent, span: .thisEvent, commit: false)
        }
        try eventStore.commit()
    }
    
    
    func getTimeInterval(from time: String) -> TimeInterval {
        let parts = time.split(separator: ":").compactMap{ Int($0) }
        return TimeInterval(parts[0] * 3600 + parts[1] * 60)
    }
    
    func getDateFromTime(time: String, day: Date) -> Date? {
        let parts = time.split(separator: ":").compactMap{ Int($0) }
        return Calendar.current.date(bySettingHour: parts[0], minute: parts[1], second: 0, of: day)
    }
    
    func clearCalendarBasedOnItemName(title: String) throws {
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



