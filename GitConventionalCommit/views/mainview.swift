//
//  mainview.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/5/25.
//

import SwiftUI
import Git

let cTemplate = """
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.

"""

struct MainView: View {
  let args = CommandLine.arguments
  @State var cUrl: URL? = nil
  @State var cType: CommitType = .docs
  @State var cScope: CommitScope = .doc
  @State var Msg: String
  @State var repo: GitRepository? = nil
  @State var status: String = ""
  
  init() {
    print(args)
    let path = (args.count > 1) ? args[1] : nil
    if path == nil {
      self.Msg = "no url provided"
      return
    }
    let url = URL(fileURLWithPath: path!)
    self.cUrl = url
    
    if url.lastPathComponent != "COMMIT_EDITMSG" {
      self.Msg = "\(args[1]) is not a commit file url"
    } else if !url.path.contains(".git") {
      self.Msg = "\(args[1]) has no git repository"
    } else {
      let repoUrl = url.pathComponents.dropLast(2).joined(separator: "/")
      do {
        self.repo = try GitRepository(atPath: repoUrl)
      } catch {
        self.Msg = "\(error)"
      }
      self.Msg = getCommitMsg(url)
    }
  }

  var body: some View {
    if repo == nil {
      Editor(msg: $Msg)
    } else {
      HSplitView {
        Sidebar(repo!)
        VStack(spacing: 0) {
          Selectors($cType, $cScope)
          Divider()
          Editor(msg: $Msg)
          Statusbar($status, commit, cancel)
        }
      }
      .foregroundColor(Color("fg"))
      .background(Color("bg"))
    }
  }

  func cancel() {
    print("Cancel button pressed")
    NSApp.terminate(nil)
  }

  func commit() {
    let msg = $Msg.wrappedValue
    if msg.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      print("Error: Commit message cannot be empty.")
      return
    }
    let message = "\(self.cType.rawValue): \(self.cScope.icon) \(msg)"
    print("Commit message: \(message)")
    let err = writeCommitMsg(message, self.cUrl!)
    if err == nil {
      NSApp.terminate(nil)
    }
    print(err!)
  }
}

struct preview: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
