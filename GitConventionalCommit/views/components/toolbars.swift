import SwiftUI

struct ConventionalToolBar: ToolbarContent {
  @EnvironmentObject var Model: DataModel

  var body: some ToolbarContent {
    ToolbarItem(
      placement: .automatic,
      content: {
        Picker("Mode", selection: $Model.commit.mode) {
          ForEach(ConventionalMode.allCases, id: \.self) {
            type in Text(type.rawValue)
          }
        }.frame(width: 100)
      })
    ToolbarItem(
      placement: .automatic,
      content: {
        Picker("Type", selection: $Model.commit.type) {
          ForEach(CommitType.allCases, id: \.self) {
            type in Text(type.rawValue)
          }
        }
        .frame(width: 130)
        .disabled([.scopeOnly, .none].contains(Model.commit.mode))
      })
    ToolbarItem(
      placement: .automatic,
      content: {
        Picker("Scope", selection: $Model.commit.scope) {
          ForEach(CommitScope.allCases, id: \.self) {
            scope in Text("\(scope.icon) \(scope.rawValue)")
          }
        }
        .frame(width: 130)
        .disabled([.typeOnly, .none].contains(Model.commit.mode))
      })
    ToolbarItem(placement: .automatic) { Spacer() }
    ToolbarItem(placement: .automatic) {
      Button("Close", action: Model.quit)
    }
    ToolbarItem(placement: .automatic) {
      Button("Commit", action: { Model.AppModal.show(.commit) })
        .buttonStyle(.borderedProminent)
    }
  }
}

struct MainToolBar: ToolbarContent {
  @EnvironmentObject var Model: DataModel
  @EnvironmentObject var Repo: RepoHandler

  var body: some ToolbarContent {
    ToolbarItem(placement: .automatic, content: { Spacer() })
    ToolbarItem(placement: .automatic) { MainMenu() }
    ToolButton(
      "Refresh", "arrow.trianglehead.2.counterclockwise",
      action: Repo.refresh
    )
    ToolButton(
      "Commit", "circle.and.line.horizontal.fill",
      disabled: Model.files.staged.isEmpty,
      action: { Model.AppModal.show(.commit) }
    )
    ToolButton("Pull", "arrowshape.down.fill", action: Repo.pull)
    ToolButton("Push", "arrowshape.up.fill", action: Repo.push)
//    ToolButton("Settings", "gearshape.fill", action: {})
    ToolButton(
      "Quit", "rectangle.portrait.and.arrow.right.fill", action: Model.quit
    )
  }
}
