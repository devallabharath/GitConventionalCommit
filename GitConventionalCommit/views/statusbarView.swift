import SwiftUI

struct StatusbarView: View {
  @EnvironmentObject var Model: DataModel

  var body: some View {
    HStack(spacing: 2) {
      if Model.AppStatus.status.isEmpty {
        EmptyView()
      } else {
        Label(Model.AppStatus.status, systemImage: Model.AppStatus.icon)
          .font(.system(size: 11))
          .foregroundColor(Model.AppStatus.color)
          .lineLimit(1)
          .onTapGesture { Model.AppModal.show(.error) }
        Spacer()
      }
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 3)
    .frame(height: 22)
    .frame(maxWidth: .infinity)
    .background(.morebg)
  }
}
