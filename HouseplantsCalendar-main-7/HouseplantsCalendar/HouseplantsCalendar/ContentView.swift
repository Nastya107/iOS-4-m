import SwiftUI

struct ContentView: View {
    
    @StateObject var userAuth: UserAuth = UserAuth.shared
    
    var body: some View {
        NavigationStack {
            if userAuth.isLoggedin {
                DoubleTabView(left: CalendarView(), right: ProfileView())
            } else {
                SignUpView()
            }
        }
    }
}
