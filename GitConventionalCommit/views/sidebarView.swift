import Git
import SwiftUI

struct SidebarView: View {
  @State private var selected = Set<UUID>()
  @EnvironmentObject var Model: DataModel
  @EnvironmentObject var Repo: RepoHandler

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      if Model.loading {
        ProgressView().controlSize(.small)
      } else {
        if Model.AppMode == .commit {
          Text("Files being commited")
            .font(.headline)
            .lineLimit(1)
            .padding(.horizontal, 10)
          List {
            ForEach(Model.files.staged) { file in FileView(file) }
          }
        } else {
          List(selection: $selected) {
            SectionView(.staged)
            SectionView(.unstaged)
            SectionView(.untracked)
          }
          .opacity(0.9)
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
    .onAppear { Repo.getFiles() }
  }

  func HeaderView() -> some View {
    let (name, stats) = Repo.getBranchInfo()
    return HStack(alignment: .center, spacing: 5) {
      Text(stats)
        .font(.caption)
        .foregroundColor(.cyan)
      Text(name)
        .font(.system(size: 13, weight: .bold))
      HStack(spacing: 2) {
        Text(String(Model.files.staged.count)).foregroundColor(.cgreen)
        Text(String(Model.files.unstaged.count)).foregroundColor(.cyellow)
        Text(String(Model.files.untracked.count)).foregroundColor(.cgray)
      }
      .font(.caption)
    }
    .padding(.vertical, 5.5)
    .padding(.horizontal, 8)
    .frame(maxWidth: .infinity)
    //    .background(.morebg)
    .lineLimit(1)
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
    case .staged: files = Model.files.staged
    case .unstaged: files = Model.files.unstaged
    case .untracked: files = Model.files.untracked
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
        case .staged: Repo.unStageAll()
        case .unstaged: Repo.stageByType(.unstaged)
        case .untracked: Repo.stageByType(.untracked)
        }
      }.padding(.bottom, 2).buttonStyle(.plain)
    })
  }

  func handleSelection(_ ids: Set<UUID>, _ opeartion: FileOperation) {
    let combined: [File]

    func filtered() -> [String] {
      combined.filter({ ids.contains($0.id) }).map(\.path)
    }

    switch opeartion {
    case .stage:
      combined = Model.files.unstaged + Model.files.untracked
      Repo.stage(filtered())
    case .unstage:
      combined = Model.files.staged
      Repo.unStage(filtered())
    case .discard:
      combined = Model.files.staged + Model.files.unstaged + Model.files.untracked
    default: combined = Model.files.staged
    }
  }
}
