//
//  sidebarfile.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/14/25.
//

import SwiftUI
import Git

struct SidebarFile: View {
  @State var hovering: Bool = false
  @State var file: File
  
  init(_ file: File) {
    self.file = file
  }
  
  var body: some View {
    HStack(spacing: 2) {
      Image(systemName: file.icon)
      Text(file.name)
      Spacer()
      Text(file.symbol)
        .fontWeight(.bold)
        .foregroundColor(file.color)
    }
    .help(file.path)
    .frame(height: 16).cornerRadius(5)
    .padding(.horizontal, 5)
    .font(.system(size: 12))
    .foregroundColor(hovering ? Color.blue : Color("fg"))
//    .background(hovering ? Color.blue : Color.clear)
    .onHover {h in hovering = h}
    
  }
}
