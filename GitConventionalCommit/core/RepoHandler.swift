import Git
import SwiftUI

class RepoHandler: ObservableObject {
  private var repo: GitRepository? = nil
  var model: DataModel
  
  init(_ model: DataModel) {
    self.model = model
    self.repo = try? GitRepository(atPath: model.cUrl!.pathComponents.dropLast(2).joined(separator: "/"))
  }
  
  func isRepo() -> Bool {
    repo != nil
  }
  
  func repoName() -> String {
    do {
      return try repo?.listReferences().currentReference?.name.shortName ?? "Changes"
    }catch {
      return "Changes"
    }
  }
  
  func branchStatus() -> String {
    let local = try? repo?.listReferences().currentReference
    let remote = try? repo?.listRemotes().remotes.first
    print(local?.name.shortName ?? "local", remote?.name ?? "remote")
    return "↓3 ↑2"
  }
  
  func getFiles() {
    model.loading = true
    model.files = Files()
    
    let files = try? repo!.listStatus(options: .default)
    
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
  
  func refresh() {
    model.refreshMsg()
    getFiles()
  }
  
  func stage(_ path: String) {
    do {
      try repo!.add(files: [path])
      getFiles()
    } catch {
      model.status = error.localizedDescription
    }
  }
  
  func stageAll() {
    do {
      try repo!.add(files: model.files.unstaged.map(\.path))
      getFiles()
    } catch {
      model.status = error.localizedDescription
    }
  }
  
  func unStage(_ path: String) {
    do {
      try repo!.reset(files: [path])
      getFiles()
    } catch {
      model.status = error.localizedDescription
    }
  }
  
  func unStageAll() {
    do {
      try repo!.reset(files: model.files.staged.map(\.path))
      getFiles()
    } catch {
      model.status = error.localizedDescription
    }
  }
  
  func discardStaged() {
    do {
      try repo!.discardChanges(in: model.files.staged.map(\.path))
      model.files.staged.removeAll()
    } catch {
      model.status = error.localizedDescription
    }
  }
  
  func discardUnstaged() {
    do {
      try repo!.discardChanges(in: model.files.unstaged.map(\.path))
      model.files.unstaged.removeAll()
    } catch {
      model.status = error.localizedDescription
    }
  }
  
  func discardChanges() {
    do {
      try repo!.discardAllLocalChanges()
      getFiles()
    } catch {
      model.status = error.localizedDescription
    }
  }
  
  func pull() {
    do {
      try repo!.pull(options: .default)
    } catch {
      model.status = error.localizedDescription
    }
  }
  
  func push() {
    do {
      try repo!.push(options: .default)
    } catch {
      model.status = error.localizedDescription
    }
  }
}
