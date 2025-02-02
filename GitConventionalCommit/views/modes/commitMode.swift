import SwiftUI

struct CommitMode: View {
  @EnvironmentObject var model: DataModel
  
  var body: some View {
    NavigationSplitView(
      sidebar: {
        SidebarView()
      },
      detail: {
        VStack(spacing: 0) {
          Divider()
          EditorView()
        }
        .frame(minWidth: 600, minHeight: 300)
        .foregroundColor(Color("fg"))
      }
  )
    .toolbar {
      ToolbarItem(placement: .automatic, content: {
        Picker("Mode", selection: $model.commit.mode) {
          ForEach(ConventionalMode.allCases, id: \.self) {
            type in Text(type.rawValue)
          }
        }.frame(width: 100)
      })
      ToolbarItem(placement: .automatic, content: {
        Picker("Type", selection: $model.commit.type) {
          ForEach(CommitType.allCases, id: \.self) {
            type in Text(type.rawValue)
          }
        }
        .frame(width: 130)
        .disabled([.scopeOnly, .none].contains(model.commit.mode))
      })
      ToolbarItem(placement: .automatic, content: {
        Picker("Scope", selection: $model.commit.scope) {
          ForEach(CommitScope.allCases, id: \.self) {
            scope in Text("\(scope.icon) \(scope.rawValue)")
          }
        }
        .frame(width: 130)
        .disabled([.typeOnly, .none].contains(model.commit.mode))
      })
      ToolbarItem(placement: .automatic){Spacer()}
      ToolbarItem(placement: .automatic){
        Button("Close", action: model.quit)
      }
      ToolbarItem(placement: .automatic){
        Button("Commit", action: {model.AppModal.show(.commit)})
        .buttonStyle(.borderedProminent)
      }
    }
//    .controlSize(.regular)
    .onAppear {
      let win = NSApp.windows.first!
      win.center()
      win.standardWindowButton(.closeButton)?.isEnabled = false
      win.standardWindowButton(.miniaturizeButton)?.isEnabled = true
      win.standardWindowButton(.zoomButton)?.isEnabled = false
    }
  }
}
