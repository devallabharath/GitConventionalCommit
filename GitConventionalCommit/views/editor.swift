//
//  editor.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/5/25.
//

import SwiftUI

struct Editor: View {
  @Binding var msg: String

  var body: some View {
    TextEditor(text: $msg)
      .scrollContentBackground(.hidden)
      .font(.system(size: 13))
      .monospaced(true)
      .lineSpacing(2)
      .padding(4)
  }
}

struct Editor_Previews: PreviewProvider {
  @State static var msg = "Preview"

  static var previews: some View {
    Editor(msg: $msg)
  }
}
