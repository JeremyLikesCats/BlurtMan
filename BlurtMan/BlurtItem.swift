//
//  StudySubjects.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 2/11/2026.
//

import Observation
import Foundation
import SwiftUI

struct BlurtItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var dates: [Date]
    var currentStage: Int = 0
    var resolvedColor: Color.Resolved
    var color: Color {
        Color(resolvedColor)
    }
    var showingOptions: Bool
    
    
    init(title: String, color: Color) {
        self.id = UUID()
        self.title = title
        self.resolvedColor = color.resolve(in: EnvironmentValues())
        self.showingOptions = false
        self.dates = []
        // HOW THIS SYSTEM WOULD WORK: Blurt after 1 day, after 3 days, after 1 week, after 2 weeks then 1 month
        // If in the middle the user doesn't feel confident, there are two cases:
        // If confidence is mid, then reset the next blurt to be after 3 days
        // If confidence is bad, then reset the next blurt to be after 1 day
        
    }
    
    var nextDate: Date? {
        return dates.indices.contains(currentStage) ? dates[currentStage] : nil
    }
    
    var isDueToday: Bool {
        guard let nextDate else {return false}
        return Calendar.current.isDateInToday(nextDate)
    }
}

@Observable
class BlurtItemStore {
    private var dateIntervals: [Int] {
        get {
            guard let rawString = UserDefaults.standard.string(forKey: "dateIntervals") else {
                return [1, 3, 7, 14, 30]
            }
            return rawString
                .split {$0 == "," || $0.isWhitespace}
                .compactMap{Int($0)}
        } 
    }
    
    var items: [BlurtItem] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }
    
    
    private let blurtItemsSaveKey = "blurtItems"
    private func save() {
        if let encodedValues = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedValues, forKey: blurtItemsSaveKey)
        }
    }
    private func load() {
        // wow this is kinda confusing
        if let savedBlurtItems = UserDefaults.standard.data(forKey: blurtItemsSaveKey),
           let decodedValues = try? JSONDecoder().decode([BlurtItem].self, from: savedBlurtItems) {
            self.items = decodedValues
        } else {
            // if nothing is saved yet then run this
            self.items = [BlurtItem(title: "Math", color: .blue), BlurtItem(title: "Science", color: .red)]
            self.setDates()
        }
    }
    
    func addItem(title: String, color: Color) {
        var newBlurtItem = BlurtItem(title: title, color: color)
        let today = Date()
        newBlurtItem.dates = dateIntervals.compactMap{
            Calendar.current.date (byAdding: .day, value: $0, to: Calendar.current.startOfDay(for: today))
        }
        items.append(newBlurtItem)
    }
    
    func setDates() {
        for blurtItem in items {
            let today = Date()
            guard let i: Int = items.firstIndex(where:  {$0.id == blurtItem.id}) else {return}
            items[i].dates = dateIntervals.compactMap{
                Calendar.current.date (byAdding: .day, value: $0, to: Calendar.current.startOfDay(for: today))
            }
        }
    }
    
    func updateReminders() {
        // Updates reminders based on current subject schedules.
        
        
    }
    
    func markItemGood(_ item: BlurtItem) {
        guard let i: Int = items.firstIndex(where:  {$0.id == item.id}) else {return}
        items[i].currentStage += 1
        items[i].showingOptions = false
    }
    
    func markItemMid(_ item: BlurtItem) {
        guard let i: Int = items.firstIndex(where:  {$0.id == item.id}) else {return}
        self.reschedule(item: item, firstStage: 1)
        items[i].showingOptions = false
    }
    
    func markItemBad(_ item: BlurtItem) {
        guard let i: Int = items.firstIndex(where:  {$0.id == item.id}) else {return}
        self.reschedule(item: item, firstStage: 0)
        items[i].showingOptions = false
    }
    
    func reschedule(item: BlurtItem, firstStage: Int) {
        guard let i: Int = items.firstIndex(where:  {$0.id == item.id}) else {return}
        let today = Date()
        items[i].dates = dateIntervals[firstStage...].compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: Calendar.current.startOfDay(for: today))
        }
    }
    
    func toggleShowingOptions(_ item: BlurtItem) {
        guard let i: Int = items.firstIndex(where:  {$0.id == item.id}) else {return}
        items[i].showingOptions.toggle()
    }
    
    func returnAsDateOrderedDict() -> [Date : [BlurtItem]] {
        var finalDictionary: [Date : [BlurtItem]] = [:]
        for item in items {
            for date in item.dates.dropFirst(item.currentStage) {
                finalDictionary[date, default: []].append(item)
            }
        }
        return finalDictionary
    }
}
