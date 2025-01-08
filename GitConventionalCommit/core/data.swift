//
//  data.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/6/25.
//

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
  var icon: String {UnicodeIcons[self] ?? ""}
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
