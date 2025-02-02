import SwiftUI

struct ErrorView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var model: DataModel

  var body: some View {
    VStack {
      Text(model.AppError.title)
        .font(.headline)
      ScrollView {
        Text(model.AppError.body)
          .font(.footnote)
          .multilineTextAlignment(.leading)
      }
      Button("Clear") {
        model.AppError.clear()
        model.AppStatus.clear()
        dismiss()
      }
    }
    .frame(maxWidth: .infinity)
    .foregroundStyle(Color("Cred"))
  }
}
