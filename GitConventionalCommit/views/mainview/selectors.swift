//
//  selectors.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/5/25.
//

import SwiftUI

struct Selectors: View {
  @Environment(\.colorScheme) var theme
  let cType: Binding<CommitType>
  let cScope: Binding<CommitScope>
  
  init(_ Type: Binding<CommitType>, _ Scope: Binding<CommitScope>) {
    self.cType = Type
    self.cScope = Scope
  }
  
  var body: some View {
    HStack(spacing: 20) {
      // Type picker
      Picker("Type", selection: self.cType) {
        ForEach(CommitType.allCases, id: \.self) {
          type in Text(type.rawValue)
        }
      }
      .frame(width: 200, height: 20)
      
      // Scope picker
      Picker("Scope", selection: self.cScope) {
        ForEach(CommitScope.allCases, id: \.self) {
          scope in Text("\(scope.icon) \(scope.rawValue)")
        }
      }
      .frame(width: 200, height: 20)
      
      // Extra spacing at end
      Spacer()
    }
    .frame(height: 30, alignment: .leading)
    .padding(.horizontal, 5)
    .background(theme == .dark ? Color.black.opacity(0.1) : Color.white)
  }
}

struct CommitSelectors_Previews: PreviewProvider {
  @State static var cType: CommitType = .chore
  @State static var cScope: CommitScope = .doc
  
  static var previews: some View {
    Selectors($cType, $cScope)
  }
}
