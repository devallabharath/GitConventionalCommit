import SwiftUI
import Git

class DataModel: ObservableObject {
  private let args = CommandLine.arguments
  private var repo: GitRepository? = nil
  private var cUrl: URL? = nil
  @Published var cType: CommitType = .docs
  @Published var cScope: CommitScope = .doc
  @Published var cMsg: String
  @Published var status: String = "some"
  @Published var loading: Bool = false
  @Published var files:Files = Files()
  
  init() {
    let path = (args.count > 1) ? args[1] : nil
    if path == nil {
      cMsg = "no url provided"
      return
    }
    let url = URL(fileURLWithPath: path!)
    cUrl = url
    
    if url.lastPathComponent != "COMMIT_EDITMSG" {
      cMsg = "\(args[1]) is not a commit file url"
    } else if !url.path.contains(".git") {
      cMsg = "\(args[1]) has no git repository"
    } else {
      let repoUrl = url.pathComponents.dropLast(2).joined(separator: "/")
      do {
        repo = try GitRepository(atPath: repoUrl)
      } catch {
        cMsg = "\(error)"
      }
      cMsg = readCommitMsg(url)
    }
    getFiles()
  }
  
  func isRepo() -> Bool {
    repo == nil
  }
  
  func fileCount() -> Int {
    files.staged.count + files.unstaged.count + files.untracked.count
  }
  
  func getFiles() {
    loading = true
    files = Files()
    
    let status = try? repo!.listStatus(options: .default)
    
    for file in status! {
      if file.hasChangesInIndex {
        files.staged.append(File(file, .staged))
        if file.hasChangesInWorktree {
          files.unstaged.append(File(file, .unstaged))
        }
      } else if file.hasChangesInWorktree {
        files.unstaged.append(File(file, .unstaged))
      } else {
        files.untracked.append(File(file, .untracked))
      }
    }
    
    loading = false
  }
  
  func stage(_ path: String)throws {
    do {
      try repo!.add(files: [path])
      getFiles()
    } catch {
      throw error
    }
  }
  
  func unStage(_ path: String)throws {
    do {
      try repo!.reset(files: [path])
      getFiles()
    } catch {
      throw error
    }
  }
  
  func quit() {
    print("Cancel button pressed")
    NSApp.terminate(nil)
  }
  
  func commit() {
    let msg = cMsg
    if msg.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      print("Error: Commit message cannot be empty.")
      return
    }
    let message = "\(cType.rawValue): \(cScope.icon) \(msg)"
    print("Commit message: \(message)")
    let err = writeCommitMsg()
    if err == nil {
      NSApp.terminate(nil)
    }
    print(err!)
  }
  
  func writeCommitMsg() -> Error? {
    do {
      try cMsg.write(toFile: cUrl!.path, atomically: true, encoding: .utf8)
      return nil
    } catch {
      return error
    }
  }
}

func readCommitMsg(_ url: URL) -> String{
  let fileManager = FileManager.default
  if fileManager.fileExists(atPath: url.path) {
    do {
      return try String(contentsOf: url, encoding: .utf8)
    } catch {
      return "Error reading file \(url.path)\n\(error)"
    }
  } else {
    return "No file found at \(url.path)"
  }
}
