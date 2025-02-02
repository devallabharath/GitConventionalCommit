import SwiftUI

struct CommitForm: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var Model: DataModel
  @EnvironmentObject var Repo: RepoHandler
  
  var body: some View {
    VStack(alignment: .center, spacing: 10) {
      CommitOptions
      CommitSubject
      CommitBody
      Buttons
    }
    .font(.system(size: 13))
    .frame(width: 500)
  }
  
  private var CommitOptions: some View {
    HStack(spacing: 10) {
      // Commit Mode
      Picker("Mode", selection: $Model.commit.mode) {
        ForEach(ConventionalMode.allCases, id: \.self) {
          type in Text(type.rawValue)
        }
      }.frame(width: 120)
      // Commit Type
      Picker("", selection: $Model.commit.type) {
        ForEach(CommitType.allCases, id: \.self) {
          type in Text(type.rawValue)
        }
      }
      .frame(width: 120)
      .disabled([.scopeOnly, .none].contains(Model.commit.mode))
      // Commit Scope
      Picker("", selection: $Model.commit.scope) {
        ForEach(CommitScope.allCases, id: \.self) {
          scope in Text("\(scope.icon) \(scope.rawValue)")
        }
      }
      .frame(width: 120)
      .disabled([.typeOnly, .none].contains(Model.commit.mode))
    }
  }
  
  private var CommitSubject: some View {
    HStack(spacing: 8) {
      Text("Subject")
      TextField("Subject", text: $Model.commit.subject)
    }
    .monospaced()
  }
  
  private var CommitBody: some View {
    HStack(alignment: .top, spacing: 8) {
      Text("Body   ")
      TextEditor(text: $Model.commit.body)
    }
    .monospaced()
    .frame(height: 120)
  }
  
  private var Buttons: some View {
    HStack(spacing: 20) {
      Button("Cancel", action: {dismiss()})
      Button("Commit", action: {
        let success = Repo.commit()
        if success {
          Model.commit.subject = ""
          Model.commit.body = ""
          Repo.refresh()
        }
        dismiss()
      })
        .buttonStyle(.borderedProminent)
    }
    .controlSize(.small)
    .frame(maxWidth: .infinity)
  }
}

