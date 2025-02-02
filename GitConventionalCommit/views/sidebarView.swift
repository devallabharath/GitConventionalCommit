import Git
import SwiftUI

struct SidebarView: View {
  @State private var selected = Set<UUID>()
  @EnvironmentObject var model: DataModel
  @EnvironmentObject var repo: RepoHandler

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      if model.loading {
        ProgressView().controlSize(.small)
      } else {
        if model.AppMode == .commit {
          Text("Files being commited")
            .font(.headline)
            .lineLimit(1)
            .padding(.horizontal, 10)
          List {
            ForEach(model.files.staged) { file in FileView(file) }
          }
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
        }
      }
    }
    .onAppear { repo.getFiles() }
    .toolbar { ToolbarItem(placement: .principal) { HeaderView() } }
  }

  func HeaderView() -> some View {
    let (name, stats) = repo.getBranchInfo()
    return HStack(spacing: 5) {
      Text(name)
      Text(stats)
        .font(.system(size: 10))
      Spacer()
    }
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
    //    .monospaced()
  }

  func SectionView(_ type: FileType) -> some View {
    let files: [File]
    switch type {
    case .staged: files = model.files.staged
    case .unstaged: files = model.files.unstaged
    case .untracked: files = model.files.untracked
    }
    return Section("\(type.rawValue): \(files.count)") {
      ForEach(files, id: (\.id)) { file in
        FileView(file).tag(file.id)
      }
    }
    .sectionActions(content: {
      let icon = type == .staged ? "minus.square.fill" : "plus.square.fill"
      Button("", systemImage: icon) {
        switch type {
        case .staged: repo.unStageAll()
        case .unstaged: repo.stageByType(.unstaged)
        case .untracked: repo.stageByType(.untracked)
        }
      }
    })
  }

  func handleSelection(_ ids: Set<UUID>, _ opeartion: FileOperation) {
    let combined: [File]

    func filtered() -> [String] {
      combined.filter({ ids.contains($0.id) }).map(\.path)
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
    default: combined = model.files.staged
    }
  }
}
