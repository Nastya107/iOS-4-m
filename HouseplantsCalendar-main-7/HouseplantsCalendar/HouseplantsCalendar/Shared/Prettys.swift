import SwiftUI

struct PrettyText: View {
    private var text: String
    private var size: CGFloat
    init(_ text: String, size: CGFloat = 42) {
        self.text = text
        self.size = size
    }
    
    var body: some View {
        Text(text)
            .font(.custom("Panama", size: size))
    }
}

struct AtypText: View {
    private var text: String
    private var size: CGFloat
    private var isMedium: Bool
    init(_ text: String, size: CGFloat, _ b: Bool = false) {
        self.text = text
        self.size = size
        self.isMedium = b
    }
    
    var body: some View {
        let font = isMedium ? "AtypDisplay-Medium" : "AtypDisplay-Regular"
        Text(text)
            .font(.custom(font, size: size))
    }
}

struct PrettyTextField: View {
    private var title: String
    @Binding private var text: String
    private var isSecure: Bool
    
    init(_ title: String, text: Binding<String>, isSecure: Bool = false) {
        self.title = title
        self._text = text
        self.isSecure = isSecure
    }
    
    var body: some View {
        field()
            .font(.custom("AtypDisplay-Regular", size: 16))
            .padding(.leading, 22)
            .padding(.vertical, 12)
            .background(.white)
            .cornerRadius(10)
            .frame(height: 48)
    }
    
    @ViewBuilder
    func field() -> some View {
        if isSecure {
            SecureField(title, text: $text)
        } else {
            TextField(title, text: $text)
        }
    }
}

struct PrettyButton: View {
    @Binding private var isActive: Bool
    private var label: String
    private var action: () -> Void
    private var width: CGFloat
    
    init(isActive: Binding<Bool> = .constant(true),
         label: String,
         width: CGFloat = .infinity,
         action: @escaping () -> Void
    ) {
        self._isActive = isActive
        self.label = label
        self.width = width
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            AtypText(label, size: 18, true)
                .padding()
                .frame(maxWidth: width, maxHeight: 42)
                .background(isActive ? Color("GrayActive") : Color("GrayInactive"))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

struct PrettyNavigationLink<Destination>: View where Destination: View {
    @Binding private var isActive: Bool
    private var label: String
    private var width: CGFloat
    private var content: () -> Destination
    
    init(isActive: Binding<Bool> = .constant(true),
         label: String,
         width: CGFloat = .infinity,
         content: @escaping () -> Destination
    ) {
        self._isActive = isActive
        self.label = label
        self.width = width
        self.content = content
    }
    
    var body: some View {
        NavigationLink {
            content()
        } label: {
            AtypText(label, size: 18, true)
                .padding()
                .frame(maxWidth: width, maxHeight: 42)
                .background(isActive ? Color("GrayActive") : Color("GrayInactive"))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}


struct PrettyDate: View {
    var date: DayModel
    var day: Date? = nil
    
    var body: some View {
        shape()
            .frame(width: 32, height: 40)
    }
    
    @ViewBuilder
    func shape() -> some View {
        let cal = Calendar.current
        if let date = date.date {
            if cal.startOfDay(for: date) == cal.startOfDay(for: day ?? Date()) {
                VStack {
                    AtypText("\(date.day)", size: 22)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .background(Circle().fill(.black).frame(width: 32))
                    Spacer()
                }
            } else {
                VStack(spacing: 4) {
                    AtypText("\(date.day)", size: 22)
                    if self.date.notifications.count > 0 {
                        Circle()
                            .strokeBorder(Color.black, lineWidth: 1)
                            .background(Circle().foregroundColor(Color("Circle")))
                            .frame(height: 8)
                    } else {
                        Color.clear.frame(height: 8)
                    }
                }
            }
        } else {
            Color.clear
        }
    }
    
}


struct Background: View {
    var height: CGFloat = 15
    
    var body: some View {
        VStack(spacing: 0) {
            Color.white
                .ignoresSafeArea()
                .frame(height: height)
            Color("Background")
                .ignoresSafeArea()
        }
    }
}


struct PlantImage: View {
    var image: UIImage?
    var color: Color = Color("Background")
    
    var body: some View {
        if let image = self.image {
            Image(uiImage: image)
                .resizable()
        } else {
            color
                .overlay {
                    Image("Camera")
                }
        }
    }
}

