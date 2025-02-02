import Git
import SwiftUI

class RepoHandler: ObservableObject {
  var model: DataModel

  init(_ model: DataModel) { self.model = model }
  
  func getBranchInfo() -> (String, String) {
    let name = try? model.repo?.listReferences().currentReference?.name.shortName
    return (name ?? "Branch", "")
  }

  func getFiles() {
    model.loading = true

    do {
      let files = try model.repo!.listStatus(options: .default)
      model.files = Files()
      for file in files {
        if file.hasChangesInIndex {
          model.files.staged.append(File(file, .staged))
          if file.hasChangesInWorktree {
            model.files.unstaged.append(File(file, .unstaged))
          }
        } else if file.hasChangesInWorktree {
          model.files.unstaged.append(File(file, .unstaged))
        } else {
          model.files.untracked.append(File(file, .untracked))
        }
      }
    } catch {
      model.setError(
        title: "Git Status Error",
        body: error.localizedDescription,
        status: "Unable to get file status...",
        kind: .error
      )
    }

    model.loading = false
  }

  func getLogs() {
    do {
      model.logs = try model.repo!.listLogRecords().records
    } catch {
      model.setError(
        title: "Git Log Error",
        body: error.localizedDescription,
        status: "Error while getting repo logs...",
        kind: .error
      )
    }
  }

  func refresh() {
    if model.AppMode == .normal {
      getLogs()
    } else {
      if let err = model.commit.readCommitFile() {
        model.setError(
          title: "Error: Reading Commit File",
          body: err.1,
          status: err.0,
          kind: .error
        )
      }
    }
    getFiles()
  }
  
  func chooseRepo(_ dir: URL) {
    model.AppError.clear()
    model.AppStatus.clear()
    do {
      model.repo = try GitRepository(atPath: dir.path)
      model.addRecents(dir.path)
      model.AppMode = .normal
      self.refresh()
    } catch {
      model.setError(
        title: "Repo Error",
        body: error.localizedDescription,
        status: "Repo Init Error..."
      )
    }
  }

  func stage(_ paths: [String]) {
    do {
      try model.repo!.add(files: paths)
    } catch {
      model.setError(
        title: "Staging Error",
        body: error.localizedDescription,
        status: "Errors while Staging files...",
        kind: .warning
      )
    }
    getFiles()
  }

  func stageByType(_ type: FileType) {
    model.AppDialog.show(
      message: "All \(type.rawValue) files will be STAGED.",
      actionTitle: "Stage",
      action: {
        let paths: [String]
        switch type {
        case .staged: paths = self.model.files.staged.map(\.path)
        case .unstaged: paths = self.model.files.unstaged.map(\.path)
        case .untracked: paths = self.model.files.untracked.map(\.path)
        }
        self.stage(paths)
      },
      severity: .standard
    )
  }

  func stageAll() {
    model.AppDialog.show(
      message: "Everything will be STAGED including untracked.",
      actionTitle: "Stage",
      action: {
        let paths = self.model.files.unstaged.map(
          \.path
        ) + self.model.files.untracked.map(\.path)
        self.stage(paths)
      },
      severity: .standard
    )
  }

  func unStage(_ path: [String]) {
    do {
      try model.repo!.reset(files: path)
    } catch {
      model.setError(
        title: "Unstaging Error",
        body: error.localizedDescription,
        status: "Errors while Unstaging files...",
        kind: .warning
      )
    }
    getFiles()
  }

  func unStageAll() {
    model.AppDialog.show(
      message: "Everything will be UNSTAGED",
      actionTitle: "UnStage",
      action: { self.unStage(self.model.files.staged.map(\.path)) },
      actionRole: .destructive,
      severity: .critical
    )
  }

  private func _discard(_ paths: [String]) {
    do {
      try model.repo!.discardChanges(in: paths)
    } catch {
      model.setError(
        title: "Discard Error",
        body: error.localizedDescription,
        status: "Errors while Discarding files...",
        kind: .warning
      )
    }
    getFiles()
  }

  func discard(_ paths: [String], _ msg: String? = nil) {
    model.AppDialog.show(
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
    case .staged: paths = self.model.files.staged.map(\.path)
    case .unstaged: paths = self.model.files.unstaged.map(\.path)
    case .untracked: paths = self.model.files.untracked.map(\.path)
    }
    discard(paths, "\(type.rawValue) files will be DISCARDED")
  }

  func discardAll() {
    discard(
      model.files.staged.map(\.path) + model.files.unstaged.map(\.path),
      "Everything will be DISCARDED"
    )
  }
  
  func commit() -> Bool {
    if model.AppMode != .commit {
      let options = GitCommitOptions(message: model.commit.parseCommit())
      do {
        try model.repo?.commit(options: options)
        return true
      } catch {
        self.model.setError(
          title: "",
          body: error.localizedDescription,
          status: "",
          kind: .error
        )
        return false
      }
    }
    
    if let (body, status) = model.commit.writeCommitFile() {
      model.setError(
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
      try model.repo!.pull(options: .default)
    } catch {
      model.setError(
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
      try model.repo!.push(options: .default)
    } catch {
      model.setError(
        title: "Push Error",
        body: error.localizedDescription,
        status: "Unable to push the repo...",
        kind: .error
      )
    }
    refresh()
  }
}
