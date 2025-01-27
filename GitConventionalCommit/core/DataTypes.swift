import SwiftUI
import Git

enum AppMode {
  case open
  case normal
  case commit
}

enum CommitType: String, CaseIterable {
  case none = "Type: None"
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
  case none = "Scope: None"
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
  .none: "",
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

enum FileType: String {
  case staged = "Staged"
  case unstaged = "Unstaged"
  case untracked = "Untracked"
}

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
        return Color("green")
      case .deleted:
        return Color("red")
      case .modified:
        return Color("yellow")
      case .renamed:
        return .orange
      case .ignored:
        return Color("gray")
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

struct Dialog {
  var visible: Bool = false
  var title: String = ""
  var message: String = ""
  var icon: String = ""
  var actionTitle: String = ""
  var action: () -> Void = {}
  var actionRole: ButtonRole? = nil
  var severity: DialogSeverity = .automatic
  
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

enum FileOperation {
  case diff
  case stage
  case unstage
  case untrack
  case stash
  case discard
}

enum StatusType {
  case none
  case success
  case warning
  case error
}

struct Status {
  var msg: String = ""
  var type: StatusType = .none
  
  var icon: String {
    switch type {
      case .none:
        return ""
      case .success:
        return "checkmark.circle.fill"
      case .warning:
        return "exclamationmark.circle.fill"
      case .error:
        return "xmark.circle.fill"
    }
  }
  
  mutating func clear() {
    msg = ""
  }
}
