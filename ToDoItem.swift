//
//  ToDoItem.swift
//  TJToDoList
//
//  Created by TejaswiniV on 25/07/25.
//

import Foundation
import SwiftUI

enum Priority: Int, CaseIterable, Codable {
    case high = 0
    case medium = 1
    case low = 2

    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .yellow
        case .low: return .green
        }
    }

    var label: String {
        switch self {
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        }
    }
}

struct TodoItem: Identifiable, Equatable, Codable {
    let id: UUID
    var text: String
    var isCompleted: Bool
    var priority: Priority
}
