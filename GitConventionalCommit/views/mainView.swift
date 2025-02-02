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
  @EnvironmentObject var model: DataModel
  @EnvironmentObject var repo: RepoHandler
  
  var body: some View {
    ViewMode(model.AppMode)
    // Dialog
    .foregroundColor(Color("fg"))
    .confirmationDialog(
      model.AppDialog.title,
      isPresented: $model.AppDialog.visible
    ) {
      Button(
        model.AppDialog.actionTitle,
        role: model.AppDialog.actionRole ?? .none
      ) {
        model.AppDialog.action()
        model.AppDialog.visible = false
      }
    } message: {
      Text(model.AppDialog.message)
    }
    .dialogSeverity(model.AppDialog.severity)
    .dialogIcon(Image(systemName: model.AppDialog.icon))
    .sheet(isPresented: $model.AppModal.visible) { ModalView() }
    // Import Folder
    .fileImporter(
      isPresented: $model.importing,
      allowedContentTypes: [.folder],
      onCompletion: {result in
        do {
          repo.chooseRepo(try result.get())
        } catch {
          model.setError(
            title: "Open Repository Error",
            body: error.localizedDescription,
            status: "Unable to open the selected folder...",
            kind: .error
          )
        }
      }
    )
  }
}
