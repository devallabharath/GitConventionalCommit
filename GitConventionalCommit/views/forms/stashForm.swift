import SwiftUI

struct StashForm: View {
  @Environment(\.dismiss) private var dismiss
  @State private var value: String = ""
  var ids: [UUID] = []

  var body: some View {
    VStack(spacing: 10) {
      Text("Stash")
        .font(.system(size: 16))
        .bold()
      TextField("Enter stash name", text: $value)
        .frame(maxWidth: 300)
      HStack(spacing: 10) {
        Button("Dismiss", action: { dismiss() }).controlSize(.large)
        Button("Stash", action: { dismiss() }).controlSize(.large)
          .buttonStyle(.borderedProminent)
      }
    }
    .padding()
  }
}
