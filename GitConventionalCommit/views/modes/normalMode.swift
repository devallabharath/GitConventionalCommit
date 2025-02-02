import SwiftUI

struct NormalMode: View {
  @Environment(\.colorScheme) var theme
  @EnvironmentObject var model: DataModel

  var body: some View {
    NavigationSplitView(
      sidebar: { SidebarView() },
      detail: {
        VStack(spacing: 0) {
          LogView()
          StatusbarView()
        }
        .frame(minWidth: 450, minHeight: 200)
        .background(theme == .dark ? Color.clear : Color.gray.opacity(0.1))
        .toolbar { ToolBar() }
      }
    )
    .controlSize(.regular)
    .onAppear {
      let win = NSApp.windows.first!
      win.isMovableByWindowBackground = false
      win.standardWindowButton(.closeButton)?.isEnabled = true
      win.standardWindowButton(.miniaturizeButton)?.isEnabled = true
      win.standardWindowButton(.zoomButton)?.isEnabled = true
    }
  }
}
