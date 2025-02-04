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
        TextButton("Cancel", action: { dismiss() })
        TextButton("Stash", .primary, action: { dismiss() })
      }
    }
    .padding()
  }
}
