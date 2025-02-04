import SwiftUI

struct ErrorView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var Model: DataModel

  var body: some View {
    VStack {
      Text(Model.AppError.title).font(.headline)
      ScrollView {
        Text(Model.AppError.body)
          .font(.footnote)
          .multilineTextAlignment(.leading)
      }
      TextButton(
        "Clear",
        action: {
          Model.AppError.clear()
          Model.AppStatus.clear()
          dismiss()
        })
    }
    .frame(maxWidth: .infinity)
    .foregroundStyle(Color("Cred"))
  }
}
