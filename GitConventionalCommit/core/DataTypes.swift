import SwiftUI
import Git

enum ApplicationMode {
  case open
  case normal
  case commit
}

struct ApplicationDialog {
  var visible: Bool = false
  private(set) var title: String = ""
  private(set) var message: String = ""
  private(set) var icon: String = ""
  private(set) var actionTitle: String = ""
  private(set) var action: () -> Void = {}
  private(set) var actionRole: ButtonRole? = nil
  private(set) var severity: DialogSeverity = .automatic
  
  mutating func toggle() { self.visible.toggle() }
  
  mutating func show(
    title: String = "Are you sure?",
    icon: String = "questionmark.app.fill",
    message: String = "",
    actionTitle: String = "Continue",
    action: @escaping () -> Void,
    actionRole: ButtonRole? = nil,
    severity: DialogSeverity = .automatic
  ) {
    self.title = title
    self.message = message
    self.icon = icon
    self.actionTitle = actionTitle
    self.action = action
    self.actionRole = actionRole
    self.severity = severity
    self.visible = true
  }
}

struct ApplicationModal {
  var visible: Bool = false
  private(set) var mode: ApplicationModalMode = .error
  
  mutating func show(_ mode: ApplicationModalMode) {
    self.mode = mode
    self.visible = true
  }
}

enum ApplicationModalMode {
  case error
  case commit
  case stash
}

class ApplicationError {
  private(set) var hasError: Bool = false
  private(set) var title: String = "Error"
  private(set) var body: String = ""
  
  func set(title: String = "Error", body: String = "") {
    self.title = title
    self.body = body
    self.hasError = true
  }
  
  func clear() {
    self.title = "Error"
    self.body = ""
    self.hasError = false
  }
}

struct ApplicationStatus {
  private(set) var status: String = ""
  private(set) var kind: ApplicationStatusKind = .none
  
  var color: Color {
    switch kind {
      case .none: return .fg
      case .success: return .cgreen
      case .warning: return .cyellow
      case .error: return .cred
    }
  }
  var icon: String {
    switch kind {
      case .none: return ""
      case .success: return "checkmark.circle.fill"
      case .warning: return "exclamationmark.circle.fill"
      case .error: return "xmark.circle.fill"
    }
  }
  
  mutating func set(msg: String, kind: ApplicationStatusKind = .none) {
    self.status = msg
    self.kind = kind
  }
  
  mutating func clear() {
    self.status = ""
    self.kind = .none
  }
}

enum ApplicationStatusKind {
  case none
  case success
  case warning
  case error
}

class CommitState {
  // normal mode
  var subject: String = ""
  var body: String = ""
  // commit mode
  var url: URL? = nil
  var msg: String = ""
  var mode: ConventionalMode = .both
  var type: CommitType = .feat
  var scope: CommitScope = .new
  
  func parsePrefix() -> String {
    var prefix: String
    switch mode {
      case .both: prefix = "\(type.rawValue): \(scope.icon) "
      case .none: prefix = ""
      case .typeOnly: prefix = "\(type.rawValue): "
      case .scopeOnly: prefix = "\(scope.icon) "
    }
    
    return prefix
  }
  
  func parseMsg() -> String? {
    let msg = msg.trimmingCharacters(in: .whitespacesAndNewlines)
    if msg.isEmpty { return nil }
    
    var parsed: String = parsePrefix()
    let lines = msg.split(separator: "\n")
    
    for line in lines {
      let l = line.trimmingCharacters(in: .whitespaces)
      if (l.count > 0 && l.first != "#") {
        parsed += "\(line)\n"
      }
    }
    
    return parsed
  }
  
  func parseCommit() -> String { "\(parsePrefix())\(subject)\n\n\(body)" }
  
  func readCommitFile() -> (String, String)? {
    if (url == nil) {
      return (
        "No commit file",
        "There is no commit file to read..."
      )
    }
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: url!.path) {
      do {
        self.msg = try String(contentsOf: url!, encoding: .utf8)
        return nil
      } catch {
        return (
          "Error while reading Commit file...",
          "url: \(url!.path)\n\(error)")
      }
    } else {
      return (
        "No Commit file at url...",
        "No file found at \(url!.path)")
    }
  }
  
  func writeCommitFile() -> (String, String)? {
    let commitMsg = parseMsg()
    if commitMsg == nil {return (
      "Commit Msg cannnot be empty...",
      "Commit Msg cannnot be empty..."
    )}
    do {
      try commitMsg!.write(toFile: url!.path, atomically: true, encoding: .utf8)
      return nil
    } catch {
      return (
        error.localizedDescription,
        "Unable to write Commit file..."
      )
    }
  }
}

enum ConventionalMode: String, CaseIterable {
  case both = "On"
  case none = "Off"
  case typeOnly = "Type Only"
  case scopeOnly = "Scope Only"
}

enum CommitType: String, CaseIterable {
  case feat = "Feat"
  case fix = "Fix"
  case docs = "Docs"
  case style = "Style"
  case chore = "Chore"
  case refactor = "Refactor"
  case revert = "Revert"
  case perf = "Perf"
  case test = "Test"
  case build = "Build"
  case ci = "CI"
}

enum CommitScope: String, CaseIterable, Identifiable {
  case ini = "Init"
  case new = "New"
  case idea = "Idea"
  case pin = "Pin"
  case add = "Add"
  case remove = "Remove"
  case delete = "Delete"
  case edit = "Edit"
  case work = "Working"
  case done = "Done"
  case bug = "Bug"
  case doc = "Doc"
  case access = "Accessibility"
  case style = "Style"
  case theme = "Theme"
  case conf = "Conf"
  case settings = "Settings"
  case perf = "Performance"
  case package = "Package"
  case deliver = "Delevery"
  case deploy = "Deploy"
  case revert = "Revert"
  
  var id: Self {self}
  var icon: String {UnicodeIcons[self]!}
}

var UnicodeIcons: [CommitScope: String] = [
  .ini: "🎉",
  .new: "✨",
  .idea: "💡",
  .pin: "📌",
  .add: "➕",
  .remove: "➖",
  .delete: "🗑",
  .edit: "✏️",
  .work: "🚧",
  .done: "✅",
  .bug : "🐛",
  .doc: "📝",
  .access: "♿️",
  .style: "💄",
  .theme: "🎨",
  .conf: "🔧",
  .settings: "⚙️",
  .perf: "📈",
  .package: "📦",
  .deliver: "🚚",
  .deploy: "🚀",
  .revert: "⏪"
]

struct File: Identifiable {
  let id = UUID()
  let type: FileType
  let path: String
  let state: GitFileStatus.State
  let hasChangesInIndex: Bool
  let hasChangesInWorktree: Bool
  
  init(_ file: GitFileStatus, _ type: FileType) {
    self.type = type
    self.path = file.path
    self.state = file.state
    self.hasChangesInIndex = file.hasChangesInIndex
    self.hasChangesInWorktree = file.hasChangesInWorktree
  }
  
  var name: String {
    let parts = path.components(separatedBy: "/")
    let last = parts.last
    switch last {
      case nil:
        return path
      case "":
        return parts.dropFirst(parts.count-2).joined(separator: "")
      default:
        return last!
    }
  }
  
  var symbol: String {
    let s = type == .staged ? state.index: state.worktree
    switch s {
      case .added:
        return "A"
      case .deleted:
        return "D"
      case .modified:
        return "M"
      case .renamed:
        return "R"
      case .ignored:
        return "·"
      case .unknown:
        return "?"
      default:
        return ""
    }
  }
  
  var color: Color {
    let s = type == .staged ? state.index: state.worktree
    switch s {
      case .added:
        return Color("Cgreen")
      case .deleted:
        return Color("Cred")
      case .modified:
        return Color("Cyellow")
      case .renamed:
        return Color("Cblue")
      case .ignored:
        return Color("Cgray")
      default:
        return Color("fg")
    }
  }
  
  var icon: String {
    if path.hasSuffix("/") {
      return "folder.fill"
    }
    return "text.page.fill"
  }
}

struct Files {
  public var staged: [File] = []
  var unstaged: [File] = []
  var untracked: [File] = []
}

enum FileType: String {
  case staged = "Staged"
  case unstaged = "Unstaged"
  case untracked = "Untracked"
}

enum FileOperation {
  case diff
  case stage
  case unstage
  case untrack
  case stash
  case discard
}
