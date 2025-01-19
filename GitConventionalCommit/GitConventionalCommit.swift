import SwiftUI

@main
struct GitConventionalCommitApp: App {
  @StateObject var model = DataModel()
  
  init() {
    DispatchQueue.main.async {
      NSApp.setActivationPolicy(.regular)
      NSApp.activate()
      NSApp.windows.first?.makeKeyAndOrderFront(nil)
    }
  }

  var body: some Scene {
    Window ("GitConventionalCommit", id: "mainwin"){
      MainView()
      .environmentObject(model)
      .environmentObject(RepoHandler(model))
      .onAppear() {
        if NSApp.windows.count > 0 {
          let win = NSApp.windows.first!
          win.center()
          win.standardWindowButton(.closeButton)?.isEnabled = false
          win.standardWindowButton(.zoomButton)?.isEnabled = false
        }
      }
    }
    Window("DiffView", id: "diffwin") {
      Text("this is the diff view")
    }
  }
}
