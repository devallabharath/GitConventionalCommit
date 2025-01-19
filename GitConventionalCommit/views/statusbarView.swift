import SwiftUI

struct StatusbarView: View {
  @EnvironmentObject var model: DataModel

  var body: some View {
    HStack(alignment: .center, spacing: 2) {
      if !model.status.isEmpty {
        Button("", systemImage: "xmark.circle") { model.status = "" }
          .buttonStyle(.plain)
      }
      Text(model.status)
      Spacer()
      HStack {
        Button("Cancel", action: model.quit)
          .frame(height: 25).cornerRadius(4)
        Button("Commit", action: model.commit)
          .frame(height: 25).cornerRadius(4)
      }
    }
    .padding(.horizontal, 10)
    .background(Color("morebg"))
  }
}
