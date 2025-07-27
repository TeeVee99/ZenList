//
//  AppDelegate.swift
//  TJToDoList
//
//  Created by TejaswiniV on 25/07/25.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    var eventMonitor: EventMonitor?

    let persistenceController = PersistenceController.shared

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "checklist", accessibilityDescription: "To-Do List")
            button.action = #selector(togglePopover(_:))
        }

        let contentView = ContentView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)

        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 350)
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(rootView: contentView)

        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let self = self, self.popover.isShown {
                self.popover.performClose(event)
            }
        }
    }

    @objc func togglePopover(_ sender: Any?) {
        guard let button = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(sender)
            eventMonitor?.stop()
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
            if let popoverWindow = popover.contentViewController?.view.window {
                popoverWindow.level = .floating
                popoverWindow.makeKeyAndOrderFront(nil)
            }

            eventMonitor?.start()
        }
    }
}

