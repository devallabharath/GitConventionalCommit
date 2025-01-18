import SwiftUI

struct ErrorView: View {
  @EnvironmentObject var model: DataModel
  
  var body: some View {
    VStack {
      Spacer()
      ScrollView {
        Text(model.cMsg)
      }
      Spacer()
      Button("Quit") {model.quit()}
      Spacer()
    }
    .padding()
  }
}
