import SwiftUI

struct MenuView: View {
  @EnvironmentObject var model: DataModel
  @EnvironmentObject var repo: RepoHandler
  
  var body: some View {
    Menu("", systemImage: "ellipsis.rectangle.fill") {
      // Repo menu
      Section("Repo") {
        Button("Pull", systemImage: "icloud.and.arrow.down.fill", action: repo.pull)
        Button("Push", systemImage: "icloud.and.arrow.up.fill", action: repo.push)
      }
      // status menu
      Section("Files") {
        Menu("Stage", systemImage: "") {
          Button("Stage UnStaged", systemImage: "", action: repo.stageAll)
          Button("Stage Untracked", systemImage: "", action: repo.stageAll)
          Button("Stage All", systemImage: "", action: repo.stageAll)
        }
        Button("UnStage All", systemImage: "", action: repo.unStageAll)
        Menu("Ignore", systemImage: "") {
          Button("Ignore Untracked", systemImage: "", action: repo.unStageAll)
        }
        Menu("Discard Changes", systemImage: "") {
          Button("Discard Staged", systemImage: "", action: repo.discardStaged)
          Button(
            "Discard Unstaged",
            systemImage: "",
            action: repo.discardUnstaged
          )
          Button("Discard All", systemImage: "", action: repo.discardChanges)
        }
        
      }
      // App menu
      Section("Warn") {
        Button("Refresh", systemImage: "arrow.clockwise", action: repo.refresh)
        Button("Quit", systemImage: "xmark", action: model.quit)
      }
    }
    .menuIndicator(.hidden)
    .menuStyle(.borderlessButton)
    .frame(width: 20, height: 20, alignment: .center)
    .font(.system(size: 20))
  }
}
