//
//  CalendarView.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 3/11/2026.
//

import SwiftUI

struct CalendarView: View {
    @Environment(BlurtItemStore.self) private var blurtItems
    @Environment(CalendarModel.self) private var calendarModel
    @State private var newBlurtItem: String = ""
    @State private var newBlurtColor: Color = .blue
    
    var body: some View {
        
        if blurtItems.returnAsDateOrderedDict().isEmpty {
            VStack {
                Spacer()
                Text("No Upcoming Blurts Scheduled!")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(40)
        } else {
            #if os(iOS)
            ScrollView {
                VStack {
                    Text("Upcoming Blurt Schedule")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    
                    ForEach(blurtItems.returnAsDateOrderedDict().keys.sorted(), id: \.self) { blurtItemListKey in
                        VStack {
                            Text(blurtItemListKey.formatted(date: .abbreviated, time: .omitted))
                                .font(.title)
                            
                            
                            VStack {
                                ForEach(blurtItems.returnAsDateOrderedDict()[blurtItemListKey] ?? []) { blurtItem in
                                    HStack {
                                        Circle()
                                            .fill(blurtItem.color)
                                            .frame(width: 24, height: 24)
                                        Text(blurtItem.title)
                                    }
                                    
                                }
                            }
                        }
                        .padding(.vertical, 15)
                    }
                    
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(40)
            }
            #endif
            #if os(macOS)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Spacer()
                    Text(blurtItems.returnAsDateOrderedDict().isEmpty ? "Blurt Schedule" : "No Blurts Scheduled!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    
                    ForEach(blurtItems.returnAsDateOrderedDict().keys.sorted(), id: \.self) { blurtItemListKey in
                        VStack {
                            Text(blurtItemListKey.formatted(date: .abbreviated, time: .omitted))
                                .font(.title)
                            
                            
                            VStack {
                                ForEach(blurtItems.returnAsDateOrderedDict()[blurtItemListKey] ?? []) { blurtItem in
                                    HStack {
                                        Circle()
                                            .fill(blurtItem.color)
                                            .frame(width: 24, height: 24)
                                        Text(blurtItem.title)
                                    }
                                    
                                }
                            }
                        }
                        .padding(.horizontal, 15)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(40)
            }
            #endif
        }
        
        
    }
    
}

#Preview {
    ContentView()
        .environment(BlurtItemStore())
        .environment(CalendarModel())
}
