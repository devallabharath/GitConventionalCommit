import SwiftUI

struct MenuView: View {
  @EnvironmentObject var model: DataModel
  @EnvironmentObject var repo: RepoHandler

  var body: some View {
    Menu("Menu", systemImage: "ellipsis") {
      // Repo menu
      Section("Repo") {
        Button("Open", action: { model.AppMode = .open })
        Button("Refresh", action: repo.refresh)
        Button("Pull", action: repo.pull)
        Button("Push", action: repo.push)
      }
      // status menu
      Section("Files") {
        Menu("Stage") {
          Button("Stage UnStaged", action: { repo.stageByType(.unstaged) })
          Button("Stage Untracked", action: { repo.stageByType(.untracked) })
          Button("Stage All", action: repo.stageAll)
        }
        Button("UnStage All", action: repo.unStageAll)
        Menu("Stash") {
          Button("Stash Staged", action: repo.unStageAll)
          Button("Stash Unstaged", action: repo.unStageAll)
          Button("Stash Untracked", action: repo.unStageAll)
          Button("Stash All", action: repo.unStageAll)
        }
      }
      Section("Harmfull") {
        Menu("Discard Changes") {
          Button("Discard Staged", action: { repo.discardByType(.staged) })
          Button("Discard Unstaged", action: { repo.discardByType(.unstaged) })
          Button("Discard All", action: repo.discardAll)
        }
      }
      // App menu
      Section("App") {
        Button("Quit", action: model.quit)
      }
    }
    .menuIndicator(.hidden)
    .menuStyle(.button)
    .font(.system(size: 20))
  }
}
