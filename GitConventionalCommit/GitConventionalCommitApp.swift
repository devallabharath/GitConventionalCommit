//
//  GitConventionalCommitApp.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/5/25.
//

import SwiftUI

@main
struct GitConventionalCommitApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

  var body: some Scene {
    WindowGroup {
      MainView()
        .onAppear {
          if let win = NSApp.windows.first {
            // win.makeMain()
            // win.makeKeyAndOrderFront(nil)
            win.center()
            win.standardWindowButton(.closeButton)?.isEnabled = false
            // win.standardWindowButton(.miniaturizeButton)?.isHidden = true
            // win.standardWindowButton(.zoomButton)?.isHidden = true
          }
        }
    }
  }
}
