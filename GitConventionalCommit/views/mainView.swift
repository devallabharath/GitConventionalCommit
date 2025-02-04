import SwiftUI

private struct ViewMode: View {
  var mode: ApplicationMode

  init(_ mode: ApplicationMode) { self.mode = mode }

  var body: some View {
    switch mode {
    case .normal: NormalMode()
    case .commit: CommitMode()
    default: OpenMode()
    }
  }
}

struct MainView: View {
  @EnvironmentObject var Model: DataModel
  @EnvironmentObject var Repo: RepoHandler

  var body: some View {
    ViewMode(Model.AppMode)
      .foregroundColor(Color("fg"))
      .background(.bg)
      // Dialog
      .confirmationDialog(
        Model.AppDialog.title,
        isPresented: $Model.AppDialog.visible
      ) {
        Button(
          Model.AppDialog.actionTitle,
          role: Model.AppDialog.actionRole ?? .none
        ) {
          Model.AppDialog.action()
          Model.AppDialog.visible = false
        }
      } message: {
        Text(Model.AppDialog.message)
      }
      .dialogSeverity(Model.AppDialog.severity)
      .dialogIcon(Image(systemName: Model.AppDialog.icon))
      .sheet(isPresented: $Model.AppModal.visible) { ModalView() }
  }
}
