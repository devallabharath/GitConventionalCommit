import SwiftUI
import Git

class DataModel: ObservableObject {
  let args = CommandLine.arguments
  @Published var mode: AppMode = .open
  @Published var AppMsg: String = ""
  @Published var cUrl: URL? = nil
  @Published var repo: GitRepository? = nil
  @Published var cMsg: String = ""
  @Published var cType: CommitType = .none
  @Published var cScope: CommitScope = .none
  @Published var status: Status = Status()
  @Published var logs: [any RepositoryLogRecord] = []
  @Published var loading: Bool = true
  @Published var files: Files = Files()
  @Published var dialog: Dialog = Dialog()
  @Published var importing: Bool = false
  @Published private(set) var recents: [String] = []
  @AppStorage("recents") private var recentsStore: String = ""
  
  init() {
    recents = parseArray(recentsStore)
    let path = (args.count > 1) ? args[1] : nil
    if path == nil { return }
    
    let url = URL(fileURLWithPath: path!)
    
    if url.lastPathComponent != "COMMIT_EDITMSG" {
      AppMsg = "\(args[1]) is not a commit file url"
    } else if !url.path.contains(".git") {
      AppMsg = "\(args[1]) has no git repository"
    } else {
      mode = .commit
      cUrl = url
      repo = try? GitRepository(atPath: url.pathComponents.dropLast(2).joined(separator: "/"))
      cMsg = readCommitMsg(url)
    }
    status.msg = "some status"
    status.type = .error
  }
  
  func clearRecents() {
    recents = []
    recentsStore = ""
  }
  
  func addRecents(_ path: String) {
    if recents.contains(path) {
      if recents.last == path {return}
      var tmp = recents.filter {$0 != path}
      tmp.append(path)
      recents = tmp
    } else {
      if recents.count > 4 {
        recents.removeFirst()
      }
      recents.append(path)
    }
    recentsStore = stringifyArray(recents)
  }
  
  func chooseRepo(_ dir: URL) {
    do {
      repo = try GitRepository(atPath: dir.path)
      addRecents(dir.path)
      mode = .normal
    } catch {
      AppMsg = error.localizedDescription
    }
  }
  
  func fileCount() -> Int {
    files.staged.count + files.unstaged.count + files.untracked.count
  }
  
  func refreshMsg() {
    cMsg = readCommitMsg(cUrl!)
  }
  
  func quit() {
    dialog.show(
      actionTitle: "Quit",
      action: {NSApp.terminate(nil)},
      actionRole: .destructive,
      severity: .critical
    )
  }
  
  func commit() {
    let msg = cMsg.trimmingCharacters(in: .whitespacesAndNewlines)
    if msg.isEmpty {
      print("Error: Commit message cannot be empty.")
      return
    }
    cMsg = "\(cType.rawValue): \(cScope.icon) \(msg)"
    print("Commit message: \(cMsg)")
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

fileprivate func parseArray(_ str: String) -> [String] {
  return str.split(separator: ",").map(String.init)
}

fileprivate func stringifyArray(_ arr: [String]) -> String {
  return arr.joined(separator: ",")
}
