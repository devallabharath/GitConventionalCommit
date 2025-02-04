import SwiftUI

struct Editor: View {
  private var text: Binding<String>

  init(_ text: Binding<String>) { self.text = text }

  var body: some View {
    VStack {
      TextEditor(text: text)
        .scrollContentBackground(.hidden)
        .font(.system(size: 12))
        .monospaced(true)
        .lineSpacing(2)
        .padding(4)

    }
    .background(.morebg)
  }
}
