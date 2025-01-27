import Cocoa
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
      // On Appear
      .onAppear() {
        let win = NSApp.windows.first!
        win.makeKeyAndOrderFront(nil)
        win.titlebarAppearsTransparent = true
      }
      // Evironment
      .environmentObject(model)
      .environmentObject(RepoHandler(model))
    }
    .windowResizability(.contentSize)
    .windowToolbarStyle(.expanded)
  }
}
