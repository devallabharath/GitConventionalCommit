//
//  editor.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/5/25.
//

import SwiftUI

struct Editor: View {
  @Environment(\.colorScheme) var theme
  let commitMsg: Binding<String>
  let commit: () -> Void
  let cancel: () -> Void

  init (_ msg: Binding<String>, _ commit: @escaping () -> Void, _ cancel: @escaping () -> Void) {
    self.commitMsg = msg
    self.commit = commit
    self.cancel = cancel
  }

  var body: some View {
    TextEditor(text: self.commitMsg)
      .scrollContentBackground(.hidden)
      .font(.custom("SauceCodePro Nerd Font", size: 13))
      .lineSpacing(2)
      .padding(4)
      // .frame(width: 550, alignment: .center)
      // Toolbar with buttons
      .toolbar{
        // Cancel button
        ToolbarItem() {
          Button("Cancel") {self.cancel()}
            .frame(height: 25)
            .cornerRadius(4)
        }
        // Commit button
        ToolbarItem() {
          Button("Commit") {self.commit()}
          .frame(height: 25)
          .background(Color.accentColor)
          .cornerRadius(4)
        }
      }
  }
}

struct Editor_Previews: PreviewProvider {
  @State static var cMsg: String = "Loading..."
  static func cancel() {}
  static func commit() {}

  static var previews: some View {
    Editor($cMsg, self.cancel, self.commit)
  }
}
