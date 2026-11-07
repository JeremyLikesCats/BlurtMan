//
//  ContentView.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 2/11/2026.
//

import SwiftUI

struct MainView: View {
    @Environment(BlurtItemStore.self) private var blurtItems
    @State private var newBlurtItem: String = ""
    @State private var newBlurtColor: Color = .blue
    
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
                                blurtItems.markItemGood(blurtItem)
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .font(.title2)
                            }
                            Button {
                                blurtItems.markItemMid(blurtItem)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(.yellow)
                                    .font(.title2)
                            }
                            Button() {
                                blurtItems.markItemBad(blurtItem)
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
                        blurtItems.addItem(title: newBlurtItem, color: newBlurtColor)
                        newBlurtItem = ""
                        
                    }
                    
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.blue)
                            .font(.title2)
                }
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(BlurtItemStore())
}
