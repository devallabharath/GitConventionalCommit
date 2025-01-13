//
//  GitConventionalCommitApp.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/5/25.
//

import SwiftUI

@main
struct GitConventionalCommitApp: App {
//  @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
  init() {
    DispatchQueue.main.async {
      NSApp.setActivationPolicy(.regular)
      NSApp.activate()
      NSApp.windows.first?.makeKeyAndOrderFront(nil)
    }
  }

  var body: some Scene {
    Window ("GitConventionalCommit", id: "main"){
      MainView()
        .onAppear() {
          if NSApp.windows.count > 0 {
            let win = NSApp.windows.first!
            win.center()
            win.standardWindowButton(.closeButton)?.isEnabled = false
            win.standardWindowButton(.zoomButton)?.isEnabled = false
          }
        }
    }
  }
}
