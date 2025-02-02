import SwiftUI

struct ModalView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var model: DataModel
  @State var hover: Bool = false

  var body: some View {
    ZStack(alignment: .topLeading) {
      VStack {
        switch model.AppModal.mode {
        case .error: ErrorView()
        case .stash: StashForm()
        case .commit: CommitForm()
        }
      }
      .padding(.vertical, 25)
      .padding(.horizontal, 10)

      Button(
        "",
        systemImage: "xmark.circle.fill",
        action: { dismiss() }
      )
      .buttonStyle(.plain)
      .foregroundColor(hover ? .primary : .secondary)
      .onHover { hover in self.hover = hover }
    }
    .padding(5)
    .ignoresSafeArea(.all, edges: .all)
    .presentationDetents([.large, .large])
    .presentationBackground(.thinMaterial)
  }
}
