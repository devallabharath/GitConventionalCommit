import Git
import SwiftUI

class RepoHandler: ObservableObject {
  private var Model: DataModel

  init(_ model: DataModel) { self.Model = model }

  func getBranchInfo() -> (String, String) {
    let name = try? Model.repo?.listReferences().currentReference?.name.shortName
    return (name ?? "Branch", "▲1")  // ▼
  }

  func getFiles() {
    Model.loading = true

    do {
      let files = try Model.repo!.listStatus(options: .default)
      Model.files = Files()
      for file in files {
        if file.hasChangesInIndex {
          Model.files.staged.append(File(file, .staged))
          if file.hasChangesInWorktree {
            Model.files.unstaged.append(File(file, .unstaged))
          }
        } else if file.hasChangesInWorktree {
          Model.files.unstaged.append(File(file, .unstaged))
        } else {
          Model.files.untracked.append(File(file, .untracked))
        }
      }
    } catch {
      Model.setError(
        title: "Git Status Error",
        body: error.localizedDescription,
        status: "Unable to get file status...",
        kind: .error
      )
    }

    Model.loading = false
  }

  func getLogs() {
    do {
      Model.logs = try Model.repo!.listLogRecords().records
    } catch {
      Model.setError(
        title: "Git Log Error",
        body: error.localizedDescription,
        status: "Error while getting repo logs...",
        kind: .error
      )
    }
  }

  func refresh() {
    if Model.AppMode == .normal {
      getLogs()
    } else {
      if let err = Model.commit.readCommitFile() {
        Model.setError(
          title: "Error: Reading Commit File",
          body: err.1,
          status: err.0,
          kind: .error
        )
      }
    }
    getFiles()
  }

  func openFolder() -> URL? {
    let panel = NSOpenPanel()
    panel.title = "Choose Repo folder"
    panel.canChooseFiles = false
    panel.canChooseDirectories = true

    let res = panel.runModal()
    return res == .OK ? panel.url : nil
  }

  func chooseRepo(_ dir: URL? = nil) {
    Model.AppError.clear()
    Model.AppStatus.clear()
    if let url = dir ?? openFolder() {
      do {
        Model.repo = try GitRepository(atPath: url.path)
        Model.addRecents(url.path)
        Model.AppMode = .normal
        self.refresh()
      } catch {
        Model.setError(
          title: "Repo Error",
          body: error.localizedDescription,
          status: "Repo Init Error..."
        )
      }
    }
  }

  func stage(_ paths: [String]) {
    do {
      try Model.repo!.add(files: paths)
    } catch {
      Model.setError(
        title: "Staging Error",
        body: error.localizedDescription,
        status: "Errors while Staging files...",
        kind: .warning
      )
    }
    getFiles()
  }

  func stageByType(_ type: FileType) {
    Model.AppDialog.show(
      message: "All \(type.rawValue) files will be STAGED.",
      actionTitle: "Stage",
      action: {
        let paths: [String]
        switch type {
        case .staged: paths = self.Model.files.staged.map(\.path)
        case .unstaged: paths = self.Model.files.unstaged.map(\.path)
        case .untracked: paths = self.Model.files.untracked.map(\.path)
        }
        self.stage(paths)
      },
      severity: .standard
    )
  }

  func stageAll() {
    Model.AppDialog.show(
      message: "Everything will be STAGED including untracked.",
      actionTitle: "Stage",
      action: {
        let paths =
          self.Model.files.unstaged.map(
            \.path
          ) + self.Model.files.untracked.map(\.path)
        self.stage(paths)
      },
      severity: .standard
    )
  }

  func unStage(_ path: [String]) {
    do {
      try Model.repo!.reset(files: path)
    } catch {
      Model.setError(
        title: "Unstaging Error",
        body: error.localizedDescription,
        status: "Errors while Unstaging files...",
        kind: .warning
      )
    }
    getFiles()
  }

  func unStageAll() {
    Model.AppDialog.show(
      message: "Everything will be UNSTAGED",
      actionTitle: "UnStage",
      action: { self.unStage(self.Model.files.staged.map(\.path)) },
      actionRole: .destructive,
      severity: .critical
    )
  }

  private func _discard(_ paths: [String]) {
    do {
      try Model.repo!.discardChanges(in: paths)
    } catch {
      Model.setError(
        title: "Discard Error",
        body: error.localizedDescription,
        status: "Errors while Discarding files...",
        kind: .warning
      )
    }
    getFiles()
  }

  func discard(_ paths: [String], _ msg: String? = nil) {
    Model.AppDialog.show(
      message: msg ?? "All Selected files will be DISCARDED",
      actionTitle: "Discard",
      action: { self._discard(paths) },
      actionRole: .destructive,
      severity: .critical
    )
  }

  func discardByType(_ type: FileType) {
    let paths: [String]
    switch type {
    case .staged: paths = self.Model.files.staged.map(\.path)
    case .unstaged: paths = self.Model.files.unstaged.map(\.path)
    case .untracked: paths = self.Model.files.untracked.map(\.path)
    }
    discard(paths, "\(type.rawValue) files will be DISCARDED")
  }

  func discardAll() {
    discard(
      Model.files.staged.map(\.path) + Model.files.unstaged.map(\.path),
      "Everything will be DISCARDED"
    )
  }

  func commit() -> Bool {
    if Model.AppMode != .commit {
      let options = GitCommitOptions(message: Model.commit.parseCommit())
      do {
        try Model.repo?.commit(options: options)
        return true
      } catch {
        self.Model.setError(
          title: "",
          body: error.localizedDescription,
          status: "",
          kind: .error
        )
        return false
      }
    }

    if let (body, status) = Model.commit.writeCommitFile() {
      Model.setError(
        title: "Commit Error",
        body: body,
        status: status,
        kind: .error
      )
      return false
    } else {
      NSApp.terminate(nil)
      return true
    }

  }

  func pull() {
    do {
      try Model.repo!.pull(options: .default)
    } catch {
      Model.setError(
        title: "Repo pull Error",
        body: error.localizedDescription,
        status: "Unable to pull the repo...",
        kind: .error
      )
    }
    refresh()
  }

  func push() {
    do {
      try Model.repo!.push(options: .default)
    } catch {
      Model.setError(
        title: "Push Error",
        body: error.localizedDescription,
        status: "Unable to push the repo...",
        kind: .error
      )
    }
    refresh()
  }
}
