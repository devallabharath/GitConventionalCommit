import SwiftUI

struct CommitMode: View {
  @EnvironmentObject var model: DataModel
  
  var body: some View {
    NavigationSplitView(
      sidebar: { SidebarView() },
      detail: {
        VStack(spacing: 0) {
          Divider()
          EditorView()
          Divider()
          StatusbarView()
        }
        .frame(minWidth: 550, minHeight: 300)
        .foregroundColor(Color("fg"))
        .toolbar {
          ToolbarItem(placement: .automatic){MenuView()}
          ToolbarItem(placement: .automatic, content: {
            Picker("Type", selection: $model.cType) {
              ForEach(CommitType.allCases, id: \.self) {
                type in Text(type.rawValue)
              }
            }.frame(width: 150)
          })
          ToolbarItem(placement: .automatic, content: {
            Picker("Scope", selection: $model.cScope) {
              ForEach(CommitScope.allCases, id: \.self) {
                scope in Text("\(scope.icon) \(scope.rawValue)")
              }
            }.frame(width: 150)
          })
        }
      }
    )
    .controlSize(.regular)
    .onAppear {
      let win = NSApp.windows.first!
      win.center()
      win.standardWindowButton(.closeButton)?.isEnabled = false
      win.standardWindowButton(.miniaturizeButton)?.isEnabled = true
      win.standardWindowButton(.zoomButton)?.isEnabled = false
    }
  }
}
