//
//  TJToDoListApp.swift
//  TJToDoList
//
//  Created by TejaswiniV on 25/07/25.
//

import SwiftUI

@main
struct TodoListApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
