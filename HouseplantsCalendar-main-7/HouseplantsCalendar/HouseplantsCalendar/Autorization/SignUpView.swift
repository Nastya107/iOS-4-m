import SwiftUI

struct SignUpView: View {
    
    @StateObject var userAuth: UserAuth = UserAuth.shared
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var password_0: String = ""
    @State private var buttonIsActive: Bool = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack(spacing: 30) {
                PrettyText("РЕГИСТРАЦИЯ")
                VStack(spacing: 16) {
                    PrettyTextField("Почта", text: $email)
                    PrettyTextField("Пароль", text: $password, isSecure: true)
                    PrettyTextField("Подтверждение пароля", text: $password_0, isSecure: true)
                }
                .onChange(of: [email, password, password_0]) { _ in
                    checkFields()
                }
                .padding(.horizontal, 19)
                VStack(spacing: 16) {
                    PrettyButton(isActive: $buttonIsActive, label: "Зарегистрироваться", width: 268) {
                        userAuth.register(email, password: password)
                    }
                    PrettyNavigationLink(label: "Войти", width: 200) {
                        SignInView()
                    }
                }
            }
        }
    }
    
    func checkFields() {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
        if regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) == nil {
            buttonIsActive = false
            return
        }
        
        if password.count == 0 {
            buttonIsActive = false
            return
        }
        
        if password != password_0 {
            buttonIsActive = false
            return
        }
        
        buttonIsActive = true
    }
}
