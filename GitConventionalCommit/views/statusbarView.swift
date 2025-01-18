import SwiftUI

struct StatusbarView: View {
  @EnvironmentObject var model: DataModel

  var body: some View {
    HStack {
      Text(model.status)
      Spacer()
      HStack {
        Button("Cancel") {
          model.dialog.show(
            actionTitle: "Quit",
            action: model.quit,
            actionRole: .destructive,
            severity: .critical
          )
        }
          .frame(height: 25).cornerRadius(4)
        Button("Commit") { model.commit() }
          .frame(height: 25).cornerRadius(4)
      }
    }
    .padding(.horizontal, 10)
    .background(Color("morebg"))
  }
}
