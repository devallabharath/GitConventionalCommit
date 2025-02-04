import Git
import SwiftUI

struct LogView: View {
  @EnvironmentObject var Model: DataModel
  @EnvironmentObject var Repo: RepoHandler

  var body: some View {
    List(Model.logs, id: \.shortHash) { log in
      Section(
        content: { LogBody(log) },
        header: { LogHeader(log) }
      )
      .monospaced()
      .listRowSeparator(.hidden)
    }
    .scrollContentBackground(.hidden)
    .background(.lessbg)
    .task { Repo.getLogs() }
  }

  private func LogBody(_ log: any RepositoryLogRecord) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading) {
        Label(log.hash, systemImage: "number")
        Label(
          log.commiterDate.formatted(date: .complete, time: .complete),
          systemImage: "calendar"
        )
        Label("\(log.authorName) (\(log.authorEmail))", systemImage: "person.crop.circle.fill")
      }
      .font(.subheadline)
      .lineLimit(1)
      .italic()
      Text(log.body).padding(.top, 10)
      Divider()
    }
    .foregroundColor(Color.gray)
    .font(.system(size: 11, weight: .light))
    .textSelection(.enabled)
  }

  private func LogHeader(_ log: any RepositoryLogRecord) -> some View {
    HStack(alignment: .center, spacing: 5) {
      CopyButton(log.shortHash)
      Text(log.subject).font(.system(size: 12))
      Spacer()
      if log.refNames.count > 0 {
        let (locals, remotes, tags) = parseNames(log.refNames)
        if !locals.isEmpty {
          Label(
            locals.joined(separator: ","),
            systemImage: "circle.dotted.circle"
          )
        }
        if !remotes.isEmpty {
          Label(
            remotes.joined(separator: ","),
            systemImage: "checkmark.icloud"
          )
        }

        if !tags.isEmpty {
          ForEach(tags, id: \.self) { tag in
            Text(" \(tag) ")
              .foregroundColor(.bg)
              .background(.fg.opacity(0.8))
              .cornerRadius(3)
          }
        }
      }
    }
    .lineLimit(1)
    .font(.caption)
    //    .font(.system(size: 9, weight: .light))
  }

  private func parseNames(_ names: String) -> ([String], [String], [String]) {
    var locals: [String] = []
    var remotes: [String] = []
    var tags: [String] = []

    for name in names.split(separator: ", ") {
      if name.contains("HEAD -> ") {
        locals.append(String(name.dropFirst(8)))
      } else if name.contains("origin/") {
        remotes.append(String(name.dropFirst(7)))
      } else if name.contains("tag: ") {
        tags.append(String(name.dropFirst(5)))
      } else {
        locals.append(String(name).trimmingCharacters(in: .whitespaces))
      }
    }

    return (locals, remotes, tags)
  }
}
