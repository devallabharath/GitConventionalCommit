import SwiftUI

struct InputView: View {
  @Environment(\.dismiss) private var dismiss
  var title: String
  var placeholder: String
  var value: Binding<String>
  
  init(_ title: String, _ placeholder: String,  _ bindingvalue: Binding<String>) {
    self.title = title
    self.placeholder = placeholder
    self.value = bindingvalue
  }
  
  var body: some View {
    VStack(spacing: 10) {
      Text(title)
        .font(.system(size: 16))
        .bold()
      TextField(placeholder, text: value)
        .frame(maxWidth: 300)
      HStack(spacing: 10) {
        Button("Dismiss", action: {dismiss()}).controlSize(.large)
        Button(title, action: {dismiss()}).controlSize(.large)
          .buttonStyle(.borderedProminent)
      }
    }
    .padding()
  }
}

