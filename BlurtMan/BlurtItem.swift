//
//  StudySubjects.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 2/11/2026.
//

import Observation
import Foundation
import SwiftUI

struct BlurtItem: Identifiable {
    let id: UUID
    var title: String
    var dates: [Date]
    var currentStage: Int = 0
    var color: Color
    
    init(title: String, color: Color) {
        self.id = UUID()
        self.title = title
        self.color = color
        let today = Date()
        // remove 0 later currently its for debugging purposes
        self.dates = [1, 3, 7, 14, 30].compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: today)
        }
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
    private let dateIntervals = [1, 3, 7, 14, 30]
    
    var items: [BlurtItem] = [BlurtItem(title: "Math", color: .blue)]
    
    func markItemGood(_ item: BlurtItem) {
        guard let i: Int = items.firstIndex(where:  {$0.id == item.id}) else {return}
        items[i].currentStage += 1
    }
    
    func markItemMid(_ item: BlurtItem) {
        self.reschedule(item: item, firstStage: 1)
    }
    
    func markItemBad(_ item: BlurtItem) {
        self.reschedule(item: item, firstStage: 0)
    }
    
    func reschedule(item: BlurtItem, firstStage: Int) {
        guard let i: Int = items.firstIndex(where:  {$0.id == item.id}) else {return}
        let today = Date()
        items[i].dates = dateIntervals[firstStage...].compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: today)
        }
    }
}
