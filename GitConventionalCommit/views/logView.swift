import SwiftUI
import Git

struct LogView: View {
  @EnvironmentObject var model: DataModel
  @EnvironmentObject var repo: RepoHandler
  @State var logs: [any RepositoryLogRecord] = []
  
  var body: some View {
    List(logs, id: \.shortHash) { log in
      Section(
        content: { LogBody(log) },
        header: { LogHeader(log) }
      )
      .monospaced()
      .listRowSeparator(.hidden)
    }
    .defaultScrollAnchor(UnitPoint.bottom)
    .scrollContentBackground(.hidden)
    .onAppear {getLogs()}
  }
  
  private func LogBody(_ log: any RepositoryLogRecord) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading) {
        Label(log.hash, systemImage: "number")
        Label(
          log.commiterDate.formatted(date: .abbreviated, time: .shortened),
          systemImage: "calendar"
        )
        Label("\(log.authorName) (\(log.authorEmail))", systemImage: "person.crop.circle.fill")
      }
      .font(.subheadline)
      .lineLimit(1)
      .italic()
      Text(log.body).padding(.top, 10).bold()
      Divider()
    }
    .foregroundColor(Color.gray)
    .font(.body)
  }
  
  private func LogHeader(_ log: any RepositoryLogRecord) -> some View {
    HStack(alignment: .center, spacing: 5) {
      Text("\(log.shortHash):")
      Text(log.subject)
        .lineLimit(1)
      Spacer()
      if log.refNames.count > 0 {
        if let remote = parseNames(log.refNames, "origin/") {
          Label(remote.trimmingCharacters(in: .whitespaces), systemImage: "cloud")
            .foregroundColor(Color("blue"))
        }
        if let tag = parseNames(log.refNames, "tag:"){
          Text(" \(tag.trimmingCharacters(in: .whitespaces)) ")
            .foregroundColor(Color("bg"))
            .background(Color("blue"))
            .cornerRadius(3)
            .font(.subheadline)
        }
      }
    }
    .font(.headline)
  }
  
  func parseNames(_ names: String, _ str: String) -> String? {
    var tag: String? = nil
    print(names)
    names.split(separator: ",").forEach {name in
      if name.contains(str) {
        tag = String(name.dropFirst(str.count+1))
      }
    }
    return tag
  }
  
  func getLogs() {
    do {
      self.logs = try model.repo!.listLogRecords().records
    } catch {
      print(error)
    }
  }
}
