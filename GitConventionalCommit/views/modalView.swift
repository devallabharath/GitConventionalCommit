import SwiftUI

struct ModalView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var Model: DataModel
  @State var hover: Bool = false

  var body: some View {
    ZStack(alignment: .topLeading) {
      VStack {
        switch Model.AppModal.mode {
        case .error: ErrorView()
        case .stash: StashForm()
        case .commit: CommitForm()
        }
      }
      .padding(10)

      Button(
        "",
        systemImage: "xmark.circle.fill",
        action: { dismiss() }
      )
      .buttonStyle(.plain)
      .foregroundColor(hover ? .primary : .secondary)
      .onHover { hover in self.hover = hover }
    }
    .padding(.horizontal, 5)
    .padding(.vertical, 2)
  }
}
