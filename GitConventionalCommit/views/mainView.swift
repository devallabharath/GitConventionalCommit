import SwiftUI

struct MainView: View {
  @EnvironmentObject var model: DataModel
  @EnvironmentObject var repo: RepoHandler
  
  var body: some View {
    if !repo.isRepo() {
      ErrorView()
    } else {
      HSplitView {
        SidebarView()
        VStack(spacing: 0) {
          SelectorView()
          Divider()
          EditorView()
          StatusbarView()
        }
      }
      .foregroundColor(Color("fg"))
      .background(Color("bg"))
      .confirmationDialog(model.dialog.title, isPresented: $model.dialog.show) {
        Button(model.dialog.actionTitle, role: model.dialog.actionRole ?? .none) {
          model.dialog.action()
          model.dialog.show = false
        }
      } message: {
        Text(model.dialog.message)
      }
      .dialogSeverity(model.dialog.severity)
      .dialogIcon(Image(systemName: model.dialog.icon))
    }
  }
}
