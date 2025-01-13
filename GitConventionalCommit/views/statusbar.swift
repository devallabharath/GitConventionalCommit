//
//  titlebar.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/11/25.
//

import SwiftUI

struct Statusbar: View {
  @State var status: Binding<String>
  let commit: () -> Void
  let cancel: () -> Void
  
  init(_ status: Binding<String>, _ commit: @escaping () -> Void, _ cancel: @escaping () -> Void) {
    self.status = status
    self.commit = commit
    self.cancel = cancel
  }
  
  var body: some View {
    HStack {
      Text(status.wrappedValue)
      Spacer()
      HStack {
        // Cancel button
        Button("Cancel") {self.cancel()}
          .frame(height: 25)
          .cornerRadius(4)
        // Commit button
        Button("Commit") {self.commit()}
          .frame(height: 25)
//          .background(Color.accentColor)
          .cornerRadius(4)
      }
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 3)
    .background(Color.gray.opacity(0.1))
  }
}

struct Statusbar_Previews: PreviewProvider {
  @State static var status = "Statusbar message"
  static func cancel() {}
  static func commit() {}
  
  static var previews: some View {
    Statusbar($status, self.commit, self.cancel)
  }
}
