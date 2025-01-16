import SwiftUI

@main
struct GitConventionalCommitApp: App {
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
