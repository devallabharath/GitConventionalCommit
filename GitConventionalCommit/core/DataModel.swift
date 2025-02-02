import Git
import SwiftUI

class DataModel: ObservableObject {
  let args = CommandLine.arguments
  @Published var AppMode: ApplicationMode = .open
  @Published var AppModal = ApplicationModal()
  @Published var AppError = ApplicationError()
  @Published var AppDialog = ApplicationDialog()
  @Published var AppStatus = ApplicationStatus()
  @Published var repo: GitRepository? = nil
  @Published var commit = CommitState()
  @Published var logs: [any RepositoryLogRecord] = []
  @Published var files: Files = Files()
  @Published var loading: Bool = true
  @Published var importing: Bool = false
  @Published private(set) var AppRecents: [String] = []
  @AppStorage("recents") private var recentsStore: String = ""

  init() {
    AppRecents = parseArray(recentsStore)
    let path = (args.count > 1) ? args[1] : nil
    if path == nil { return }

    let url = URL(fileURLWithPath: path!)

    if url.lastPathComponent != "COMMIT_EDITMSG" {
      AppError.set(body: "\(args[1]) is not a commit file url")
      AppStatus.set(msg: "\(args[1]) is not a commit file url", kind: .error)
    } else if !url.path.contains(".git") {
      AppError.set(body: "\(args[1]) has no git repository")
      AppStatus.set(msg: "\(args[1]) has no git repository", kind: .error)
    } else {
      AppMode = .commit
      self.commit.url = url
      self.repo = try? GitRepository(
        atPath: url.pathComponents.dropLast(2).joined(separator: "/"))
      let err = self.commit.readCommitFile()
      if err != nil { AppError.set(title: err!.0, body: err!.1) }
    }
  }

  func clearRecents() {
    AppRecents = []
    recentsStore = ""
  }

  func addRecents(_ path: String) {
    if AppRecents.contains(path) {
      if AppRecents.last == path { return }
      var tmp = AppRecents.filter { $0 != path }
      tmp.append(path)
      AppRecents = tmp
    } else {
      if AppRecents.count > 4 {
        AppRecents.removeFirst()
      }
      AppRecents.append(path)
    }
    recentsStore = stringifyArray(AppRecents)
  }

  func setError(
    title: String = "Error", body: String, status: String,
    kind: ApplicationStatusKind = .none
  ) {
    self.AppError.set(title: title, body: body)
    self.AppStatus.set(msg: status, kind: kind)
  }

  func quit() {
    AppDialog.show(
      actionTitle: "Quit",
      action: { NSApp.terminate(nil) },
      actionRole: .destructive,
      severity: .critical
    )
  }
}

private func parseArray(_ str: String) -> [String] {
  return str.split(separator: ",").map(String.init)
}

private func stringifyArray(_ arr: [String]) -> String {
  return arr.joined(separator: ",")
}
