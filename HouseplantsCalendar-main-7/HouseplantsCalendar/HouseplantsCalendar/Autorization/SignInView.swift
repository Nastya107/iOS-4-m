import SwiftUI

struct SignInView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var userAuth: UserAuth = UserAuth.shared
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var buttonIsActive: Bool = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack(spacing: 30) {
                PrettyText("АВТОРИЗАЦИЯ")
                VStack(spacing: 16) {
                    PrettyTextField("Почта", text: $email)
                    PrettyTextField("Пароль", text: $password, isSecure: true)
                }
                .onChange(of: [email, password]) { _ in
                    checkFields()
                }
                .padding(.horizontal, 19)
                VStack(spacing: 16) {
                    PrettyButton(isActive: $buttonIsActive, label: "Войти", width: 268) {
                        Task {
                            await userAuth.login(email, password: password)
                        }
                    }
                    PrettyButton(label: "Зарегистрироваться", width: 268) {
                        dismiss()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
        
        buttonIsActive = true
    }
    
}
