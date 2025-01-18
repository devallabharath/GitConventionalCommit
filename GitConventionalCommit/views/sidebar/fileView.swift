import SwiftUI

struct FileView: View {
  @State var hovering: Bool = false
  @State var file: File
  
  init(_ file: File) {
    self.file = file
  }
  
  var body: some View {
    HStack(spacing: 2) {
      Image(systemName: file.icon)
      Text(file.name)
      Spacer()
      Text(file.symbol)
        .fontWeight(.bold)
        .foregroundColor(file.color)
    }
    .help(file.path)
    .font(.system(size: 11))
    .foregroundColor(hovering ? Color.accentColor : Color("fg"))
    .onHover {h in hovering = h}
  }
}
