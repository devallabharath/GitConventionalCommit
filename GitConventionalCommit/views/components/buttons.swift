import SwiftUI

struct TextButton: View {
  var title: String
  var action: () -> Void
  var width: CGFloat?
  var style: styles

  enum styles {
    case none
    case auto
    case plain
    case link
    case primary
    case destructive
  }

  init(
    _ title: String,
    _ style: styles = .plain,
    width: CGFloat? = nil,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.action = action
    self.width = width
    self.style = style
  }

  private var button: some View { Button(title, action: action) }

  var body: some View {
    switch style {
    case .auto: button.buttonStyle(.automatic)
    case .plain: button.buttonStyle(plainStyle(width))
    case .link: button.buttonStyle(linkStyle(width))
    case .primary: button.buttonStyle(okStyle(width))
    case .destructive: button.buttonStyle(cancelStyle(width))
    default: button
    }
  }
}

struct CopyButton: View {
  private let str: String
  @State private var hovering = false
  @State private var isCopied = false

  init(_ str: String) { self.str = str }

  var body: some View {
    Button(
      str,
      systemImage: isCopied ? "checkmark" : "list.clipboard.fill",
      action: {
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(str, forType: .string)
        isCopied.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          isCopied.toggle()
        }
      }
    )
    .buttonStyle(.plain)
    .help("Copy")
    .foregroundColor(Color("fg").opacity(hovering ? 1 : 0.8))
    .onHover { hovering in self.hovering = hovering }
  }
}

struct ToolButton: ToolbarContent {
  private let title: String
  private let icon: String
  private let placement: ToolbarItemPlacement
  private var disabled: Bool?
  private let action: () -> Void
  @State private var hover: Bool = false

  init(
    _ title: String,
    _ icon: String,
    placement: ToolbarItemPlacement = .automatic,
    disabled: Bool? = false,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.icon = icon
    self.placement = placement
    self.disabled = disabled
    self.action = action
  }

  var body: some ToolbarContent {
    let fg: Color = hover ? .blue : .fg.opacity(0.8)

    ToolbarItem(
      placement: placement,
      content: {
        VStack(spacing: 3) {
          Label("", systemImage: icon)
            .font(.system(size: 11))
            .frame(width: 11, height: 11)
            .foregroundColor(disabled! ? Color("fg").opacity(0.4) : fg)
          Text(title).font(.system(size: 7, weight: .light))
        }
        //        .foregroundColor(disabled! ? Color("fg").opacity(0.4) : fg)
        .onHover { hover in self.hover = hover }
        .onTapGesture { action() }
        .disabled(disabled!)
      }
    )
  }
}

struct defaultStyle: ButtonStyle {
  var width: CGFloat?
  init(_ w: CGFloat?) { self.width = w ?? 90 }
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .font(.body)
      .frame(width: width, height: 25, alignment: .center)
      .foregroundColor(.fg.opacity(configuration.isPressed ? 0.7 : 1))
      .background(.bg.opacity(configuration.isPressed ? 0.7 : 1))
      .cornerRadius(5)
  }
}

struct okStyle: ButtonStyle {
  var width: CGFloat?
  init(_ w: CGFloat?) { self.width = w ?? 90 }
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .font(.body)
      .frame(width: width, height: 25, alignment: .center)
      .contentShape(Rectangle())
      .foregroundColor(.white.opacity(configuration.isPressed ? 0.7 : 1))
      .background(.blue.opacity(configuration.isPressed ? 0.7 : 1))
      .cornerRadius(5)
  }
}

struct cancelStyle: ButtonStyle {
  var width: CGFloat?
  init(_ w: CGFloat?) { self.width = w ?? 90 }
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .font(.body)
      .frame(width: width, height: 25, alignment: .center)
      .contentShape(Rectangle())
      .foregroundColor(.red.opacity(configuration.isPressed ? 0.7 : 1))
      .background(.lessbg.opacity(configuration.isPressed ? 0.7 : 1))
      .cornerRadius(5)
  }
}

struct plainStyle: ButtonStyle {
  var width: CGFloat?
  init(_ w: CGFloat?) { self.width = w ?? 90 }
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .font(.body)
      .frame(width: width, height: 25, alignment: .center)
      .contentShape(Rectangle())
      .foregroundColor(.fg.opacity(configuration.isPressed ? 0.7 : 1))
      .background(.lessbg.opacity(configuration.isPressed ? 0.7 : 1))
      .cornerRadius(5)
  }
}

struct linkStyle: ButtonStyle {
  var width: CGFloat?
  init(_ w: CGFloat?) { self.width = w ?? 90 }
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .font(.body)
      .frame(width: width, height: 25, alignment: .center)
      .foregroundColor(.blue.opacity(configuration.isPressed ? 0.7 : 1))
  }
}
