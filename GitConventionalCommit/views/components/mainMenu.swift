import SwiftUI

struct MainMenu: View {
  @EnvironmentObject var Model: DataModel
  @EnvironmentObject var Repo: RepoHandler

  var body: some View {
    Menu("Menu", systemImage: "ellipsis") {
      // Repo menu
      Section("Repo") {
        Button("Open", action: { Model.AppMode = .open })
        Button("Refresh", action: Repo.refresh)
        Button("Pull", action: Repo.pull)
        Button("Push", action: Repo.push)
      }
      // status menu
      Section("Files") {
        Menu("Stage") {
          Button("Stage UnStaged", action: { Repo.stageByType(.unstaged) })
          Button("Stage Untracked", action: { Repo.stageByType(.untracked) })
          Button("Stage All", action: Repo.stageAll)
        }
        Button("UnStage All", action: Repo.unStageAll)
        Menu("Stash") {
          Button("Stash Staged", action: { Model.AppModal.show(.stash) })
          Button("Stash Unstaged", action: Repo.unStageAll)
          Button("Stash Untracked", action: Repo.unStageAll)
          Button("Stash All", action: Repo.unStageAll)
        }
      }
      Section("Harmfull") {
        Menu("Discard Changes") {
          Button("Discard Staged", action: { Repo.discardByType(.staged) })
          Button("Discard Unstaged", action: { Repo.discardByType(.unstaged) })
          Button("Discard All", action: Repo.discardAll)
        }
      }
      // App menu
      Section("App") {
        Button("Quit", action: Model.quit)
      }
    }
    .menuIndicator(.hidden)
    .menuStyle(.button)
    .font(.system(size: 20))
  }
}
