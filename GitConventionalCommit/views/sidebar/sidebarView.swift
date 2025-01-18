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
          SectionView("Staged", model.files.staged)
          SectionView("UnStaged", model.files.unstaged)
          SectionView("UnTracked", model.files.untracked)
        }
        .contextMenu(forSelectionType: UUID.self) { ids in
          Button("state") {model.status = ids.first?.uuidString ?? ""}
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
  
  func SectionView(_ title: String, _ files: [File]) -> some View {
    Section(title) {
      ForEach(files) {file in
        FileView(file)
          .tag(file.id)
      }
    }
  }
}
