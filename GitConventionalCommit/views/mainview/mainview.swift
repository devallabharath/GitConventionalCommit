//
//  mainview.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/5/25.
//

import SwiftUI

struct MainView: View {
  let args = CommandLine.arguments
  @State var cUrl: URL? = nil
  @State var cType: CommitType = .docs
  @State var cScope: CommitScope = .doc
  @State var cMsg: String = ""

  var body: some View {
    // HStack(spacing: 0) {
      // Sidebar()
      VStack(spacing: 0) {
        Selectors($cType, $cScope)
        Editor($cMsg, self.commit, self.cancel)
      }
      .onAppear(perform: {
        let path = (args.count > 1) ? args[1] : nil
        if path == nil {
          self.cMsg = "no url provided"
          return
        }
        self.cUrl = URL(fileURLWithPath: path!)
        self.cMsg = getCommitMsg(self.cUrl!)
      })
    //}
  }

  func cancel() {
    print("Cancel button pressed")
    NSApplication.shared.terminate(nil)
  }

  func commit() {
    if self.cMsg.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      print("Error: Commit message cannot be empty.")
      return
    }
    let message = "\(self.cType.rawValue): \(self.cScope.icon) \(self.cMsg)"
    print("Commit message: \(message)")
    NSApplication.shared.terminate(nil)
  }
}

struct MianView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
