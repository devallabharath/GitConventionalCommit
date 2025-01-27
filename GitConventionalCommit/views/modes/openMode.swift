import SwiftUI

struct OpenMode: View {
  @Environment(\.colorScheme) var theme
  @EnvironmentObject var model: DataModel
  @State private var selected: UUID?
  
  var body: some View {
    HStack(spacing: 0) {
      mainContent
      recentsView
    }
    .frame(width: 740, height: 432)
    .onAppear {
      let win = NSApp.windows.first!
      win.isMovableByWindowBackground = true
      win.standardWindowButton(.closeButton)?.isEnabled = true
      win.standardWindowButton(.zoomButton)?.isEnabled = false
      win.standardWindowButton(.miniaturizeButton)?.isEnabled = true
    }
    .onDrop(of: [.fileURL], isTargeted: .constant(true)) { providers, _ in
      _ = providers.first!
        .loadDataRepresentation(for: .fileURL) { data, _  in
          if let data,
             let url = URL(dataRepresentation: data, relativeTo: nil) {
            print(url.path)
            Task {
              await model.chooseRepo(url)
            }
        }
      }
      return true
    }
  }
  
  private var mainContent: some View {
    VStack(spacing: 0) {
      Spacer().frame(height: 32)
      ZStack {
        if theme == .dark {
          Rectangle()
            .frame(width: 104, height: 104)
            .foregroundColor(.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .blur(radius: 64)
            .opacity(0.5)
        }
        Image(nsImage: NSApp.applicationIconImage)
          .resizable()
          .frame(width: 128, height: 128)
      }
      Text(NSLocalizedString("GitCC", comment: ""))
        .font(.system(size: 36, weight: .bold))
      .help("Copy System Information to Clipboard")
      
      Spacer().frame(height: 40)
      HStack {
        VStack(alignment: .center, spacing: 8) {
          Button("Open Directory", action: {
            model.importing.toggle()
          }).buttonStyle(.borderedProminent).controlSize(.large)
          Button("Quit", action: {
            NSApp.terminate(nil)
          })
          .controlSize(.large)
        }
      }
      Spacer()
      Text(model.AppMsg)
        .foregroundStyle(.red)
        .font(.caption)
        .italic()
        .padding()
    }
    .padding(.top, 20)
    .padding(.horizontal, 56)
    .padding(.bottom, 16)
    .frame(width: 460)
    .background(theme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.5))
  }
  
  private func recentFolder(_ path: String) -> some View {
    HStack(spacing: 8) {
      Label("", systemImage: "folder.fill")
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
    .pointerStyle(.link)
    .onTapGesture {
      model.chooseRepo(URL(fileURLWithPath: path))
    }
  }
  
  private var recentsView: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack {
        Text("Recents")
          .font(.headline)
        Spacer()
        Button("Clear") {model.clearRecents()}
          .buttonStyle(.link)
          .pointerStyle(.link)
      }
      if model.recents.isEmpty {
        Text(NSLocalizedString("No Recent Projects", comment: ""))
          .font(.body)
          .foregroundColor(.secondary)
      } else {
        ForEach(model.recents.reversed(), id: \.self) { path in
          recentFolder(path)
        }
      }
      Spacer()
    }
    .padding()
    .frame(width: 280)
  }
}
