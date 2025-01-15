//
//  sidebar.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/5/25.
//

import SwiftUI
import Git

struct Sidebar: View {
  @State var loading:Bool = true
  @State var files:Files = Files()
  @State var repo:GitRepository
  
  init(_ repo: GitRepository) {
    self.repo = repo
  }
  
  var body: some View {
    VStack(spacing: 0){
      if loading {
        ProgressView()
      } else {
        Header()
        Divider()
        ScrollView {
          VStack(spacing: 10) {
            if files.staged.count+files.unstaged.count+files.untracked.count == 0 {
              Text("No changes found")
              Button(" Quit ", action: {exit(0)})
            } else {
              if files.staged.count > 0 {renderFiles("Staged", files.staged)}
              if files.unstaged.count > 0 {renderFiles("UnStaged", files.unstaged)}
              if files.untracked.count > 0 {renderFiles("UnTracked", files.untracked)}
            }
          }
        }
        .padding(.vertical, 5)
        .background(Color("lessbg"))
      }
    }
    .frame(minWidth: 100, maxWidth: 300, maxHeight: .infinity)
    .background(Color("morebg"))
    .onAppear(perform: getFiles)
  }
  
  func getFiles() {
    loading = true
    files = Files()
    
    let status = try? repo.listStatus(options: .default)
    
    for file in status! {
      if file.hasChangesInIndex {
        files.staged.append(File(file, .staged))
        if file.hasChangesInWorktree {
          files.unstaged.append(File(file, .unstaged))
        }
      } else if file.hasChangesInWorktree {
        files.unstaged.append(File(file, .unstaged))
      } else {
        files.untracked.append(File(file, .untracked))
      }
    }
    
    loading = false
  }
  
  func Header() -> some View {
    HStack {
      Text("Changes")
      Spacer()
      Button("", systemImage: "arrow.clockwise", action: getFiles)
        .buttonStyle(.plain)
        .font(.system(size: 13))
        .help("Refresh")
    }
    .padding(.horizontal, 5)
    .frame(height: 30)
  }
  
  func Title(_ t: String, _ c: Int) -> some View {
    HStack(spacing: 5) {
      Text(t).bold()
      Text(String(c)).fontWeight(.light)
      Spacer()
    }
    .font(.system(size: 11))
  }
  
  func renderFiles(_ title: String, _ files: [File]) -> some View {
    VStack(spacing: 4) {
      Title(title, files.count)
      ForEach(files) {file in
        SidebarFile(file)
        .contextMenu {
          Button("Stage") {
            try? repo.add(files: [file.path])
            getFiles()
          }
          Button("Unstage") {
            try? repo.reset(files: [file.path])
            getFiles()
          }
        }
      }
    }
    .padding(.horizontal, 5)
  }
}

struct Sidebar_Previews: PreviewProvider {
  @State static var repo = try? GitRepository(atPath: "/Users/devallabharath/config/")
  
  static var previews: some View {
    Sidebar(repo!)
  }
}
