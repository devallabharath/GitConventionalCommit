import SwiftUI
import Git

class DataModel: ObservableObject {
  private let args = CommandLine.arguments
  @Published var cUrl: URL? = nil
  @Published var cType: CommitType = .docs
  @Published var cScope: CommitScope = .doc
  @Published var cMsg: String
  @Published var status: String = ""
  @Published var loading: Bool = false
  @Published var files: Files = Files()
  @Published var dialog: Dialog = Dialog()
  
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
      cMsg = readCommitMsg(url)
    }
  }
  
  func fileCount() -> Int {
    files.staged.count + files.unstaged.count + files.untracked.count
  }
  
  func refreshMsg() {
    cMsg = readCommitMsg(cUrl!)
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
