import SwiftUI
import Git

struct SidebarView: View {
  @ObservedObject var model: DataModel
  
  init(_ model: DataModel) {
    self.model = model
  }
  
  var body: some View {
    VStack(spacing: 0){
      if model.loading {
        ProgressView()
      } else {
        HeaderView()
        Divider()
        ScrollView {
          VStack(spacing: 10) {
            if model.fileCount() == 0 {
              Text("No changes found")
              Button(" Quit ", action: {exit(0)})
            } else {
              if model.files.staged.count > 0 {SectionView("Staged", model.files.staged)}
              if model.files.unstaged.count > 0 {SectionView("UnStaged", model.files.unstaged)}
              if model.files.untracked.count > 0 {SectionView("UnTracked", model.files.untracked)}
            }
          }
          .padding(.horizontal, 5)
        }
        .padding(.vertical, 5)
        .background(Color("lessbg"))
      }
    }
    .frame(minWidth: 100, maxWidth: 300, maxHeight: .infinity)
    .background(Color("morebg"))
  }
  
  func HeaderView() -> some View {
    HStack {
      Text("Changes")
      Spacer()
      Button("", systemImage: "arrow.clockwise", action: model.getFiles)
        .buttonStyle(.plain)
        .font(.system(size: 13))
        .help("Refresh")
    }
    .padding(.horizontal, 5)
    .frame(height: 30)
  }
  
  func TitleView(_ t: String, _ c: Int) -> some View {
    HStack(spacing: 5) {
      Text(t).bold()
      Text(String(c)).fontWeight(.light)
      Spacer()
    }
    .font(.system(size: 11))
  }
  
  func SectionView(_ title: String, _ files: [File]) -> some View {
    VStack(spacing: 4) {
      TitleView(title, files.count)
      ForEach(files) {file in
        FileView(file)
        .contextMenu {
          Button("Stage") {
            try? model.stage(file.path)
          }
          Button("Unstage") {
            try? model.unStage(file.path)
          }
        }
      }
    }
    .padding(.horizontal, 5)
  }
}

struct FileView: View {
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
    .frame(height: 16)
    .padding(.horizontal, 5)
    .font(.system(size: 12))
    .foregroundColor(hovering ? Color.blue : Color("fg"))
    .onHover {h in hovering = h}
  }
}

struct Sidebar_Previews: PreviewProvider {
  static var previews: some View {
    SidebarView(DataModel())
  }
}
