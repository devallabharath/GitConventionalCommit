import SwiftUI

private struct ViewMode: View {
  var mode: AppMode
  
  init(_ mode: AppMode) { self.mode = mode }
  
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
  
  var body: some View {
    ViewMode(model.mode)
    // Dialog
    .foregroundColor(Color("fg"))
    .confirmationDialog(model.dialog.title, isPresented: $model.dialog.visible) {
      Button(model.dialog.actionTitle, role: model.dialog.actionRole ?? .none) {
        model.dialog.action()
        model.dialog.visible = false
      }
    } message: {
      Text(model.dialog.message)
    }
    .dialogSeverity(model.dialog.severity)
    .dialogIcon(Image(systemName: model.dialog.icon))
    // Import Folder
    .fileImporter(
      isPresented: $model.importing,
      allowedContentTypes: [.folder],
      onCompletion: {result in
        do {
          model.chooseRepo(try result.get())
        } catch {
          model.cMsg = error.localizedDescription
        }
      }
    )
  }
}
