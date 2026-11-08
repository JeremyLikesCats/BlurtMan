//
//  ContentView.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 2/11/2026.
//

import SwiftUI

struct MainView: View {
    @Environment(BlurtItemStore.self) private var blurtItems
    @Environment(CalendarModel.self) private var calendarModel
    @State private var newBlurtItem: String = ""
    @State private var newBlurtColor: Color = .blue
    @State private var showDuplicateError: Bool = false
    
    private let defaultColor: Color = .blue
    
    var body: some View {
        VStack {
            Spacer() 
            VStack {
                Text(blurtItems.items.filter {$0.isDueToday}.count > 0 ? "Today's Blurts" : "No Blurts to Do!")
                    .font(.title)
                    .fontWeight(.bold)
                ForEach(blurtItems.items.filter {$0.isDueToday}) { blurtItem in
                    
                    HStack {
                        Button() {
                            blurtItems.toggleShowingOptions(blurtItem)
                        } label: {
                            Circle()
                                .fill(blurtItem.color)
                                .frame(width: 24, height: 24)
                            Text(blurtItem.title)
                        }
                        if blurtItem.showingOptions {
                            Button() {
                                blurtItems.markItemGood(blurtItem, calendarModel: calendarModel)
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .font(.title2)
                            }
                            Button {
                                blurtItems.markItemMid(blurtItem, calendarModel: calendarModel)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(.yellow)
                                    .font(.title2)
                            }
                            Button() {
                                blurtItems.markItemBad(blurtItem, calendarModel: calendarModel)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.red)
                                        .font(.title2)
                            }
                        }
                        
                        
                        
                    }
                }
            }
            Spacer()
            HStack {
                ColorPicker("Select Color", selection: $newBlurtColor)
                    .padding()
                    .labelsHidden()
                TextField("Enter new item", text: $newBlurtItem)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button() {
                    if newBlurtItem.trimmingCharacters(in: .whitespaces).count > 0 {
                        showDuplicateError = blurtItems.addItem(title: newBlurtItem, color: newBlurtColor, calendarModel: calendarModel)
                        newBlurtItem = ""
                    }
                    
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.blue)
                            .font(.title2)
                }
            }
            if !showDuplicateError {
                Text("Couldn't add subject; Subject already exists.")
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(BlurtItemStore())
        .environment(CalendarModel())
}
