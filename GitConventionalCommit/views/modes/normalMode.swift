import SwiftUI

struct NormalMode: View {
  @EnvironmentObject var Model: DataModel
  @EnvironmentObject var Repo: RepoHandler

  var body: some View {
    NavigationSplitView(
      sidebar: { SidebarView() },
      detail: {
        VStack(spacing: 0) {
          LogView()
          StatusbarView()
        }
        .frame(minWidth: 450, minHeight: 200)
        .toolbar {
          ToolbarItem(
            placement: .navigation,
            content: { BranchInfo }
          )
          MainToolBar()
        }
      }
    )
    .onAppear {
      let win = NSApp.windows.first!
      win.titlebarAppearsTransparent = false
      win.toggleToolbarShown(nil)
      win.isMovableByWindowBackground = false
      win.standardWindowButton(.zoomButton)?.isEnabled = true
    }
  }

  private var BranchInfo: some View {
    let path = Model.repo?.localPath?.split(separator: "/").last ?? ""
    let (name, diff) = Repo.getBranchInfo()
    let s = Model.files.staged.count
    let u = Model.files.unstaged.count
    let t = Model.files.untracked.count

    return HStack(spacing: 5) {
      Label("", systemImage: "folder")
        .font(.system(size: 16))
        .frame(width: 32, height: 32)
      VStack(alignment: .leading) {
        Text(path).font(.headline)
        HStack(alignment: .center, spacing: 3) {
          Text(diff).foregroundColor(.fg.opacity(0.8))
          Text(name).font(.system(size: 11))
          if s > 0 { Text(String(s)).foregroundColor(.cgreen) }
          if u > 0 { Text(String(u)).foregroundColor(.cyellow) }
          if t > 0 { Text(String(t)).foregroundColor(.fg.opacity(0.8)) }
          if s + u + t == 0 { Label("", systemImage: "checkmark").bold().foregroundColor(.cgreen) }
        }
        //        .bold()
        .font(.system(size: 9))
      }
    }
    .lineLimit(1)
  }
}
