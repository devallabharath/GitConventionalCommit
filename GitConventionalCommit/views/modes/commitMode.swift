import SwiftUI

struct CommitMode: View {
  @EnvironmentObject var Model: DataModel

  var body: some View {
    NavigationSplitView(
      sidebar: {
        SidebarView()
      },
      detail: {
        VStack(spacing: 0) {
          Editor($Model.commit.msg)
          StatusbarView()
        }
        .frame(minWidth: 600, minHeight: 300)
      }
    )
    .toolbar { ConventionalToolBar() }
    .onAppear {
      let win = NSApp.windows.first!
      win.center()
      win.level = .floating
      win.standardWindowButton(.closeButton)?.isEnabled = false
      win.standardWindowButton(.miniaturizeButton)?.isEnabled = true
      win.standardWindowButton(.zoomButton)?.isEnabled = false
    }
  }
}
