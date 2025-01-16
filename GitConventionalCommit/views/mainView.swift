import SwiftUI

struct MainView: View {
  @StateObject var model = DataModel()
  
  var body: some View {
    if model.isRepo() {
      VStack {
        Spacer()
        Text(model.cMsg)
        Spacer()
        Button("Quit") {model.quit()}
        Spacer()
      }
      .padding()
    } else {
      HSplitView {
        SidebarView(model)
        VStack(spacing: 0) {
          SelectorView(model)
          Divider()
          EditorView(model)
          StatusbarView(model)
        }
      }
      .foregroundColor(Color("fg"))
      .background(Color("bg"))
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
