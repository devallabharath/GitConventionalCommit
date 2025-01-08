//
//  delegate.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/6/25.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
  // Activate & focus the window on launch
  func applicationDidFinishLaunching(_ N: Notification) {
    if #available(macOS 14.0, *)  {
      NSApp.activate()
    } else {
      NSApp.activate(ignoringOtherApps: true)
    }
    
    // FIX: not activated with git commit
    // print(NSApp.windows.count)
    NSApp.windows.first?.makeKeyAndOrderFront(nil)
  }

  // Terminate app after last window closed
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    true
  }
}
