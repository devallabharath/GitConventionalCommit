import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationWillFinishLaunching(_ notification: Notification) {
    NSApp.setActivationPolicy(.regular)
    NSApp.activate()
    NSApp.windows.first?.makeKeyAndOrderFront(nil)
  }
}

@main
struct GitConventionalCommitApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject var model = DataModel()

  var body: some Scene {
    Window("GitCC", id: "mainwin") { MainView() }
      // Evironment
      .environmentObject(model)
      .environmentObject(RepoHandler(model))
      .windowResizability(.contentSize)
      .windowToolbarStyle(.expanded)
  }
}
