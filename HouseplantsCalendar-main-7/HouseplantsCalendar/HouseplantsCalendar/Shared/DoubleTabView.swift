import SwiftUI

struct DoubleTabView<ContentL, ContentR>: View where ContentL: View, ContentR: View {
        
    enum Side {
        case left
        case right
    }
    
    var left: ContentL
    var right: ContentR
    @State var chosen: Side = .left
        
    var body: some View {
        ZStack(alignment: .bottom) {
            if chosen == .left {
                left
            } else {
                right
            }
            LinearGradient(colors:  [.clear, Color("GrayGradient").opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .frame(height: 138)
            tabbar()
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color("Tabbar"))
                .frame(height: 58)
                .cornerRadius(29)
        }
    }
    
    @ViewBuilder
    func tabbar() -> some View {
        HStack(spacing: 16) {
            Image(systemName: "calendar")
                .font(.system(size: 30))
                .foregroundColor(chosen == .left ? .black : Color("GrayXmark"))
                .onTapGesture {
                    chosen = .left
                }
            Divider()
                .frame(width: 2, height: 30)
            Image(systemName: "person")
                .font(.system(size: 30))
                .foregroundColor(chosen == .right ? .black : Color("GrayXmark"))
                .onTapGesture {
                    chosen = .right
                }
        }
    }
}

