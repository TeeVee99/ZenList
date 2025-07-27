//
//  PriorityDot.swift
//  TJToDoList
//
//  Created by TejaswiniV on 25/07/25.
//

import SwiftUI

struct PriorityDot: View {
    let priority: Priority
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Circle()
            .fill(priority.color)
            .frame(width: isSelected ? 16 : 12, height: isSelected ? 16 : 12)
            .overlay(
                Circle()
                    .stroke(Color.primary.opacity(isSelected ? 0.8 : 0), lineWidth: 2)
            )
            .onTapGesture {
                onSelect()
            }
            .help(priority.label)
    }
}
