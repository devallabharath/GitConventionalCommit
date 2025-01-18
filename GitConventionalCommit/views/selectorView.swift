import SwiftUI

struct SelectorView: View {
  @EnvironmentObject var model: DataModel
  
  var body: some View {
    HStack(spacing: 20) {
      // Type picker
      Picker("Type", selection: $model.cType) {
        ForEach(CommitType.allCases, id: \.self) {
          type in Text(type.rawValue)
        }
      }
      .frame(width: 200, height: 20)
      
      // Scope picker
      Picker("Scope", selection: $model.cScope) {
        ForEach(CommitScope.allCases, id: \.self) {
          scope in Text("\(scope.icon) \(scope.rawValue)")
        }
      }
      .frame(width: 200, height: 20)
      
      // Extra spacing at end
      Spacer()
    }
    .frame(height: 30, alignment: .leading)
    .padding(.horizontal, 5)
    .background(Color("morebg"))
  }
}
