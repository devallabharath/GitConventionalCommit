import SwiftUI
import Git

struct SidebarView: View {
  @State private var selected = Set<UUID>()
  @EnvironmentObject var model: DataModel
  @EnvironmentObject var repo: RepoHandler
  
  var body: some View {
    VStack(spacing: 0){
      HeaderView()
      Divider()
      if model.loading {
        ProgressView()
      } else {
        List(selection: $selected) {
          SectionView(.staged)
          SectionView(.unstaged)
          SectionView(.untracked)
        }
        .contextMenu(forSelectionType: UUID.self) { ids in
          Button("Diff") { handleSelection(ids, .diff) }
          Divider()
          Button("Stage") { handleSelection(ids, .stage) }
          Button("UnStage") { handleSelection(ids, .unstage) }
          Divider()
          Button("UnTrack") { handleSelection(ids, .untrack) }
          Button("Stash") { handleSelection(ids, .stash) }
          Button("Discard") { handleSelection(ids, .discard) }
        }
        .listStyle(.sidebar)
      }
    }
    .frame(minWidth: 100, maxWidth: 300, maxHeight: .infinity)
    .background(Color("morebg"))
    .onAppear { repo.getFiles() }
  }
  
  func HeaderView() -> some View {
    HStack(spacing: 2) {
      Text(repo.repoName())
      Text(repo.branchStatus())
        .font(.system(size: 10))
      Spacer()
      MenuView()
    }
    .padding(.horizontal, 5)
    .frame(height: 30)
  }
  
  func FileView(_ file: File) -> some View {
    HStack(spacing: 2) {
      Image(systemName: file.icon)
      Text(file.name)
      Spacer()
      Text(file.symbol)
        .fontWeight(.bold)
        .foregroundColor(file.color)
    }
    .help(file.path)
    .font(.system(size: 11))
  }
  
  func SectionView(_ type: FileType) -> some View {
    var files: [File]
    switch type {
      case .staged: files = model.files.staged
      case .unstaged: files = model.files.unstaged
      default: files = model.files.untracked
    }
    
    return Section("\(type.rawValue): \(files.count)") {
      ForEach(files) { file in
        FileView(file).tag(file.id)
      }
    }
  }
  
  func handleSelection(_ ids: Set<UUID>, _ opeartion: FileOperation) {
    let combined: [File]
    
    func filtered() -> [String] {
      combined.filter({ids.contains($0.id)}).map({$0.path})
    }
    
    switch opeartion {
      case .stage:
        combined = model.files.unstaged + model.files.untracked
        repo.stage(filtered())
      case .unstage:
        combined = model.files.staged
        repo.unStage(filtered())
      case .discard:
        combined = model.files.staged + model.files.unstaged + model.files.untracked
        repo.discardChanges(filtered())
      default: combined = model.files.staged
    }
  }
}
