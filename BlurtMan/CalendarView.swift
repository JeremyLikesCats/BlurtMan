//
//  CalendarView.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 3/11/2026.
//

import SwiftUI

struct CalendarView: View {
    @Environment(BlurtItemStore.self) private var blurtItems
    @State private var newBlurtItem: String = ""
    @State private var newBlurtColor: Color = .blue
    
    var body: some View {
        
        ScrollView {
            VStack {
                Spacer()
                Text(blurtItems.returnAsDateOrderedDict().count > 0 ? "Blurt Schedule" : "No Blurts Scheduled!")
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
        
    }
    
}

#Preview {
    ContentView()
        .environment(BlurtItemStore())
}
