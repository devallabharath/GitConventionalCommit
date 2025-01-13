//
//  sidebar.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/5/25.
//

import SwiftUI
import Git

enum Tab {
  case staged
  case unstaged
  case untracked
}

struct Sidebar: View {
  @Environment(\.colorScheme) var theme
  @State var loading:Bool = true
  @State var files:Files = Files()
  @State var repo:GitRepository
  @State private var selectedTab:Tab = .staged
  
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
          VStack(spacing: 5) {
            if files.staged.count > 0 {renderFiles("Staged", files.staged)}
            if files.unstaged.count > 0 {renderFiles("UnStaged", files.unstaged)}
            if files.untracked.count > 0 {renderFiles("UnTracked", files.untracked)}
          }
        }
      }
    }
    .frame(minWidth: 100, maxWidth: 300, maxHeight: .infinity)
    .background(Color.gray.opacity(0.15))
    .onAppear(perform: getFiles)
  }
  
  func getFiles() {
    loading = true
    files = Files()
    
    let status = try? repo.listStatus(options: .default)
    
    for file in status! {
      if file.hasChangesInIndex {
        files.staged.append(File(file))
        if file.hasChangesInWorktree {
          files.unstaged.append(File(file))
        }
      } else if file.hasChangesInWorktree {
        files.unstaged.append(File(file))
      } else {
        files.untracked.append(File(file))
      }
    }
    
    loading = false
  }
  
  func Header() -> some View {
    HStack {
      Text("Changes")
      Spacer()
      Button("R", action: getFiles)
    }
    .padding(.horizontal, 5)
    .frame(height: 30)
  }
  
  func Title(_ t: String, _ c: Int) -> some View {
    HStack {
      Text(t)
        .font(.system(size: 12, weight: .bold))
      Spacer()
      Text(String(c))
        .font(.system(size: 9, weight: .light))
    }
    .padding(.horizontal, 5)
  }
  
  func renderFiles(_ title: String, _ files: [File]) -> some View {
    VStack(spacing: 0) {
      Title(title, files.count)
      ForEach(files) {file in
        HStack(spacing: 4) {
          Image(systemName: file.icon)
          Text(file.name)
            .help(file.path)
          Spacer()
          Text(file.symbol)
            .fontWeight(.bold)
            .foregroundColor(file.color)
        }
        .font(.system(size: 11))
        .frame(height: 25, alignment: .center)
        .padding(.horizontal, 8)
        .onTapGesture {
          switch title {
            case "Staged":
              try? repo.reset(files: [file.path])
            case "UnStaged":
              try? repo.add(files: [file.path])
            default:
              try? repo.add(files: [file.path])
          }

          getFiles()
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
