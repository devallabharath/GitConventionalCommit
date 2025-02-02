import SwiftUI

struct StatusbarView: View {
  @EnvironmentObject var model: DataModel

  var body: some View {
    HStack(spacing: 2) {
      if model.AppStatus.status.isEmpty {
        EmptyView()
      } else {
        Label(model.AppStatus.status, systemImage: model.AppStatus.icon)
          .foregroundColor(model.AppStatus.color)
          .lineLimit(1)
          .onTapGesture { model.AppModal.show(.error) }
        Spacer()
      }
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 3)
    .frame(height: 25)
    .frame(maxWidth: .infinity)
    .background(.background)
  }
}
