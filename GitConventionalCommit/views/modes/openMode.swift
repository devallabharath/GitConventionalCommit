import SwiftUI

struct OpenMode: View {
  @Environment(\.colorScheme) var theme
  @EnvironmentObject var Model: DataModel
  @EnvironmentObject var Repo: RepoHandler

  var body: some View {
    HStack(spacing: 0) {
      mainContent
      recentsView
    }
    .frame(width: 740, height: 435)
    .onAppear {
      let win = NSApp.windows.first!
      win.isMovableByWindowBackground = true
      win.standardWindowButton(.closeButton)?.isEnabled = true
      win.standardWindowButton(.zoomButton)?.isEnabled = false
      win.standardWindowButton(.miniaturizeButton)?.isEnabled = true
    }
    .onDrop(of: [.fileURL], isTargeted: .constant(true)) { providers, _ in
      _ = providers.first!
        .loadDataRepresentation(for: .fileURL) { data, _ in
          if let data,
            let url = URL(dataRepresentation: data, relativeTo: nil)
          {
            DispatchQueue.main.async { self.Repo.chooseRepo(url) }
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
        TextButton(
          "Open", .primary, width: 180,
          action: { Repo.chooseRepo() }
        )
        TextButton(
          "Quit", .destructive, width: 180,
          action: Model.quit
        )
      }
      Spacer()
      Text(Model.AppStatus.status)
        .foregroundStyle(.red)
        .font(.caption)
        .lineLimit(1)
        .italic()
        .padding()
        .onTapGesture { Model.AppModal.show(.error) }
    }
    .padding(.top, 32)
    .padding(.horizontal, 56)
    .frame(width: 460)
  }

  private var recentsView: some View {
    List {
      if Model.AppRecents.isEmpty {
        Text("No Recent Projects")
          .font(.body)
          .foregroundColor(.secondary)
      } else {
        headerView
        ForEach(Model.AppRecents.reversed(), id: \.self) { path in
          recentFolder(path)
        }
      }
    }
    .scrollDisabled(true)
    .listStyle(.sidebar)
    .frame(width: 280)
  }

  private var headerView: some View {
    HStack(spacing: 5) {
      Text("Recents")
      Spacer()
      TextButton("Clear", .link, width: 40, action: Model.clearRecents)
    }
  }
}

private struct recentFolder: View {
  private var path: String
  @State var hover: Bool = false
  @EnvironmentObject var Repo: RepoHandler

  init(_ path: String) { self.path = path }

  var body: some View {
    HStack(spacing: 8) {
      Label("", systemImage: "folder.fill")
        .font(.system(size: 16))
        .frame(width: 32, height: 32)
      VStack(alignment: .leading) {
        Text(path.split(separator: "/").last ?? "??")
          .font(.system(size: 13, weight: .semibold))
        Text(path)
          .font(.system(size: 11))
          .truncationMode(.head)
      }
      Spacer()
    }
    .help(path)
    .lineLimit(1)
    .frame(maxWidth: .infinity)
    .frame(height: 36)
    .onHover { hover in self.hover = hover }
    .foregroundColor(hover ? .blue : .fg)
    .onTapGesture { Repo.chooseRepo(URL(fileURLWithPath: path)) }
  }
}
