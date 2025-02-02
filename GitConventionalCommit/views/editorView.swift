import SwiftUI

struct EditorView: View {
  @EnvironmentObject var model: DataModel

  var body: some View {
    TextEditor(text: $model.commit.msg)
      .scrollContentBackground(.hidden)
      .font(.system(size: 12))
      .monospaced(true)
      .lineSpacing(2)
      .padding(4)
  }
}
