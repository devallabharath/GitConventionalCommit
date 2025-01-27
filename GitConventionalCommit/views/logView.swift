import SwiftUI
import Git

struct LogView: View {
  @EnvironmentObject var model: DataModel
  @EnvironmentObject var repo: RepoHandler
  
  var body: some View {
    List(model.logs, id: \.shortHash) { log in
      Section(
        content: { LogBody(log) },
        header: { LogHeader(log) }
      )
      .monospaced()
      .listRowSeparator(.hidden)
    }
    .scrollContentBackground(.hidden)
    .onAppear {repo.getLogs()}
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
    .font(.body)
    .textSelection(.enabled)
  }
  
  private func LogHeader(_ log: any RepositoryLogRecord) -> some View {
    HStack(alignment: .center, spacing: 5) {
      CopyButton(log.shortHash)
      Text(log.subject).font(.headline).lineLimit(1)
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
              .foregroundColor(Color("bg"))
              .background(Color("fg"))
              .cornerRadius(3)
          }
        }
      }
    }
    .font(.subheadline)
  }
  
  func parseNames(_ names: String) ->
    ([String], [String], [String]) {
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
