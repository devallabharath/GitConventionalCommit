import SwiftUI

struct ToolBar: ToolbarContent {
  @EnvironmentObject var Repo: RepoHandler

  var body: some ToolbarContent {
    ToolbarItem(placement: .automatic) { MenuView() }
    ToolbarItem {
      Button(
        "Refresh",
        systemImage: "arrow.trianglehead.2.counterclockwise",
        action: Repo.refresh
      )
    }
    ToolbarItem {
      Button(
        "Commit",
        systemImage: "circle.and.line.horizontal.fill",
        action: {
          Repo.model.AppModal.show(.commit)
        }
      )
    }
    ToolbarItem {
      Button("Pull", systemImage: "arrowshape.down.fill", action: Repo.pull)
    }
    ToolbarItem {
      Button("Push", systemImage: "arrowshape.up.fill", action: Repo.push)
    }
    ToolbarItem {
      Button("Settings", systemImage: "gearshape.fill", action: {})
    }
    ToolbarItem {
      Button(
        "Quit", systemImage: "rectangle.portrait.and.arrow.right.fill", action: Repo.model.quit)
    }
    ToolbarItem(placement: .automatic) { Spacer() }
  }
}
