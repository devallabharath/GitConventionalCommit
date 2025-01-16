import SwiftUI

struct EditorView: View {
  @ObservedObject var model:DataModel
  
  init(_ model: DataModel) {
    self.model = model
  }

  var body: some View {
    TextEditor(text: $model.cMsg)
      .scrollContentBackground(.hidden)
      .font(.system(size: 12))
      .monospaced(true)
      .lineSpacing(2)
      .padding(4)
  }
}

struct EditorView_Previews: PreviewProvider {
  static var previews: some View {
    EditorView(DataModel())
  }
}
