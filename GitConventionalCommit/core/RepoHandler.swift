import Git
import SwiftUI

class RepoHandler: ObservableObject {
  var model: DataModel
  
  init(_ model: DataModel) {
    self.model = model
  }
  
  func branchName() -> String? {
    do {
      return try model.repo?.listReferences().currentReference?.name.shortName ?? nil
    }catch {
      return nil
    }
  }
  
  func branchStatus() -> String {
//    let local = try? repo?.listReferences().currentReference
//    let remote = try? repo?.listRemotes().remotes.first
//    print(local?.name.shortName ?? "local", remote?.name ?? "remote")
    return "↓3 ↑2"
  }
  
  func getFiles() {
    model.loading = true
    model.files = Files()
    
    let files = try? model.repo!.listStatus(options: .default)
    
    for file in files! {
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
    
    model.loading = false
  }
  
  func getLogs() {
    do {
      model.logs = try model.repo!.listLogRecords().records
    } catch {
      model.status.msg = error.localizedDescription
    }
  }
  
  func refresh() {
    if model.mode == .normal {
      getLogs()
    } else {
      model.refreshMsg()
    }
    getFiles()
  }
  
  func stage(_ path: [String]) {
    do {
      try model.repo!.add(files: path)
      getFiles()
    } catch {
      model.status.msg = error.localizedDescription
    }
  }
  
  func stageUnstaged() {
    model.dialog.show(
      message: "All unstaged files will be STAGED.",
      actionTitle: "Stage",
      action: { self.stage(self.model.files.unstaged.map(\.path)) },
      severity: .standard
    )
  }
  
  func stageAll() {
    model.dialog.show(
      message: "Everything will be STAGED including untracked.",
      actionTitle: "Stage",
      action: { self.stage(self.model.files.unstaged.map(\.path)) },
      severity: .standard
    )
  }
  
  func unStage(_ path: [String]) {
    do {
      try model.repo!.reset(files: path)
      getFiles()
    } catch {
      model.status.msg = error.localizedDescription
    }
  }
  
  func unStageAll () {
    model.dialog.show(
      message: "Everything will be UNSTAGED",
      actionTitle: "UnStage",
      action: { self.unStage(self.model.files.staged.map(\.path)) },
      actionRole: .destructive,
      severity: .critical
    )
  }
  
  func discardChanges(_ paths: [String], _ msg: String? = nil) {
    func fn(_ paths: [String]) {
      do {
        try model.repo!.discardChanges(in: paths)
        getFiles()
      } catch {
        model.status.msg = error.localizedDescription
      }
    }
    
    model.dialog.show(
      message: msg ?? "Selected files will be DISCARDED",
      actionTitle: "Discard",
      action: { fn(paths) },
      actionRole: .destructive,
      severity: .critical
    )
  }
  
  func discardStaged() {
    discardChanges(
      model.files.staged.map(\.path),
      "Staged changes will be DISCARDED"
    )
  }
  
  func discardUnstaged() {
    discardChanges(
      model.files.unstaged.map(\.path),
      "UnStaged changes will be DISCARDED"
    )
  }
  
  func discardAll() {
    discardChanges(
      model.files.staged.map(\.path) + model.files.unstaged.map(\.path),
      "Everything will be DISCARDED"
    )
  }
  
  func pull() {
    do {
      try model.repo!.pull(options: .default)
    } catch {
      model.status.msg = error.localizedDescription
    }
  }
  
  func push() {
    do {
      try model.repo!.push(options: .default)
    } catch {
      model.status.msg = error.localizedDescription
    }
  }
}
