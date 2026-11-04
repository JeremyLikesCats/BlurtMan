//
//  ContentView.swift
//  BlurtMan
//
//  Created by Jeremy Zhou on 2/11/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(BlurtItemStore.self) private var blurtItems
    @State private var newBlurtItem: String = ""
    @State private var newBlurtColor: Color = .blue
    
    var body: some View {
        VStack {
            VStack {
                ForEach(blurtItems.items.filter {$0.isDueToday}) { blurtItem in
                    
                    HStack {
                        Circle()
                            .fill(blurtItem.color)
                            .frame(width: 24, height: 24)
                        Text(blurtItem.title)
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
                                .foregroundStyle(.gray)
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
            HStack {
                ColorPicker("Select Color", selection: $newBlurtColor)
                    .padding()
                    .labelsHidden()
                TextField("Enter new item", text: $newBlurtItem)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(BlurtItemStore())
}
