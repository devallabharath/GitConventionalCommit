import SwiftUI

struct CopyButton: View {
  private let str: String
  @State private var hovering = false
  @State private var isCopied = false
  
  init(_ str: String) { self.str = str }
  
  var body: some View {
    Button(
      str,
      systemImage: isCopied ? "checkmark" : "list.clipboard.fill",
      action: {
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(str, forType: .string)
        isCopied.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          isCopied.toggle()
        }
      }
    )
    .buttonStyle(.plain)
    .help("Copy")
    .foregroundColor(Color("fg").opacity(hovering ? 1 : 0.8))
    .onHover { hovering in self.hovering = hovering}
  }
}
