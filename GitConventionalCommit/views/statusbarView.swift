import SwiftUI

struct StatusbarView: View {
  @Environment(\.colorScheme) var theme
  @EnvironmentObject var model: DataModel

  var body: some View {
    HStack(alignment: .center, spacing: 2) {
      if !model.status.msg.isEmpty {
        Button("", systemImage: model.status.icon) { model.status.clear() }
          .buttonStyle(.plain)
      }
      Text(model.status.msg)
      Spacer()
      if model.mode == .commit {
        HStack {
          Button("Cancel", action: model.quit)
          Button("Commit", action: model.commit)
            .buttonStyle(.borderedProminent)
        }
      }
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 3)
    .background(.background.opacity(1))
//    .background(Color("gray").opacity(0.1))
  }
}
