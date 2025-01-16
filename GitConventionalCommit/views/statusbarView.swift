import SwiftUI

struct StatusbarView: View {
  @ObservedObject var model:DataModel
  
  init(_ model: DataModel) {
    self.model = model
  }
  
  var body: some View {
    HStack {
      Text(model.status)
      Spacer()
      HStack {
        Button("Cancel") {model.quit()}
          .frame(height: 25).cornerRadius(4)
        Button("Commit") {model.commit()}
          .frame(height: 25).cornerRadius(4)
      }
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 3)
    .background(Color("morebg"))
  }
}

struct Statusbar_Previews: PreviewProvider {
  static var previews: some View {
    StatusbarView(DataModel())
  }
}
