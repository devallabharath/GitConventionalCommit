import SwiftUI

struct MenuView: View {
  @EnvironmentObject var model: DataModel
  @EnvironmentObject var repo: RepoHandler
  
  var body: some View {
    Menu("", systemImage: "ellipsis.rectangle.fill") {
      // Repo menu
      Section("Repo") {
        Button("Pull", action: repo.pull)
        Button("Push", action: repo.push)
      }
      // status menu
      Section("Files") {
        Menu("Stage") {
          Button("Stage UnStaged", action: repo.stageUnstaged)
          Button("Stage Untracked", action: repo.stageAll)
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
          Button("Discard Staged", action: repo.discardStaged)
          Button("Discard Unstaged", action: repo.discardUnstaged)
          Button("Discard All", action: repo.discardAll)
        }
      }
      // App menu
      Section("App") {
        Button("Refresh", action: repo.refresh)
        Button("Quit", action: model.quit)
      }
    }
    .menuIndicator(.hidden)
    .menuStyle(.borderlessButton)
    .frame(width: 20, height: 20, alignment: .center)
    .font(.system(size: 20))
  }
}
