import SwiftUI

struct OpenMode: View {
  @Environment(\.colorScheme) var theme
  @EnvironmentObject var model: DataModel
  @EnvironmentObject var repo: RepoHandler
  @State private var selected: UUID?

  var body: some View {
    HStack(spacing: 0) {
      mainContent
      recentsView
    }
    //    .ignoresSafeArea(.all, edges: .top)
    .frame(width: 740, height: 435)
    .onAppear {
      let win = NSApp.windows.first!
      win.isMovableByWindowBackground = true
      win.standardWindowButton(.closeButton)?.isEnabled = true
      win.standardWindowButton(.zoomButton)?.isEnabled = false
      win.standardWindowButton(.miniaturizeButton)?.isEnabled = true
      //      model.clearRecents()
    }
    .onDrop(of: [.fileURL], isTargeted: .constant(true)) { providers, _ in
      _ = providers.first!
        .loadDataRepresentation(for: .fileURL) { data, _ in
          if let data,
            let url = URL(dataRepresentation: data, relativeTo: nil)
          {
            print(url.path)
            Task {
              await repo.chooseRepo(url)
            }
          }
        }
      return true
    }
  }

  private var mainContent: some View {
    VStack(spacing: 0) {
      Spacer().frame(height: 36)
      ZStack {
        if theme == .dark {
          Rectangle()
            .frame(width: 104, height: 104)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .blur(radius: 64)
            .opacity(0.4)
        }
        Image(nsImage: NSApp.applicationIconImage)
          .resizable()
          .frame(width: 128, height: 128)
      }
      Text("Git Conventional Commit")
        .font(.system(size: 20, weight: .bold))
      Text("Version 0.0.6")
        .monospaced()
        .font(.system(size: 10, weight: .light))
        .help("Copy System Information to Clipboard")

      Spacer().frame(height: 40)
      VStack(alignment: .center, spacing: 8) {
        Button(
          "Open Directory",
          action: {
            model.importing.toggle()
          }
        ).buttonStyle(.borderedProminent).controlSize(.large)
        Button(
          "Quit",
          action: {
            NSApp.terminate(nil)
          }
        )
        .controlSize(.large)
      }
      Spacer()
      Text(model.AppStatus.status)
        .foregroundStyle(.red)
        .font(.caption)
        .lineLimit(1)
        .italic()
        .padding()
        .onTapGesture { model.AppModal.show(.error) }
    }
    .padding(.top, 32)
    .padding(.horizontal, 56)
    //    .padding(.bottom, 16)
    .frame(width: 460)
    .background(theme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.5))
  }

  private func recentFolder(_ path: String) -> some View {
    HStack(spacing: 8) {
      Label("", systemImage: "folder.fill")
        .font(.system(size: 16))
        .frame(width: 32, height: 32)
      VStack(alignment: .leading) {
        Text(path.split(separator: "/").last ?? "??")
          .foregroundColor(.primary)
          .font(.system(size: 13, weight: .semibold))
          .lineLimit(1)
        Text(path)
          .foregroundColor(.primary)
          .font(.system(size: 11))
          .lineLimit(1)
          .truncationMode(.head)
      }
    }
    .help(path)
    .frame(height: 36)
    .contentShape(Rectangle())
    .onTapGesture {
      repo.chooseRepo(URL(fileURLWithPath: path))
    }
  }

  private var recentsView: some View {
    List {
      if model.AppRecents.isEmpty {
        Text("No Recent Projects")
          .font(.body)
          .foregroundColor(.secondary)
      } else {
        ForEach(model.AppRecents.reversed(), id: \.self) { path in
          recentFolder(path)
        }
      }
    }
    .listStyle(.sidebar)
    .frame(width: 280)
  }
}
