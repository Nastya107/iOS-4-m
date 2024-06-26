import SwiftUI

struct User: Codable {
    var avatar: String?
    var firstName: String?
    var secondName: String?
    var middleName: String?
    var login: String = "profile_0"
    let mail: String
    var phone: String?
    var telegram: String?
}

class UserAuth: ObservableObject {
    
    static let shared: UserAuth = UserAuth()
    
    @Published var isLoggedin = false
    @Published var user: User? = nil
    
    let baseURL: String = "localhost"
    
    func register(_ mail: String, password: String)  {
        register(mail: mail, password: password) { res in
            switch res {
            case .success():
                self.user = User(mail: mail)
                self.isLoggedin = true
            case .failure(_):
                return
            }
        }
        DispatchQueue.main.async {
            self.user = User(mail: mail)
            self.isLoggedin = true
        }
    }
    
    func login(_ mail: String, password: String) async {
        login(mail: mail, password: password) { res in
            switch res {
            case .success(let user):
                self.user = user
                self.isLoggedin = true
            case .failure(_):
                return
            }
        }
        DispatchQueue.main.async {
            self.user = User(mail: mail)
            self.isLoggedin = true
        }
    }
    
    func register(mail: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/register") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(["mail": mail, "password": password])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(.success(()))
                }
            }
        }.resume()
    }
    
    func login(mail: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(["mail": mail, "password": password])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("ERROR API: \(error)")
            } else {
                let decoder = JSONDecoder()
                
                do {
                    let res = try decoder.decode(User.self, from: data!)
                    DispatchQueue.main.async {
                        completion(.success(res))
                    }
                } catch {
                    print("ERROR DECODING: \(error)")
                }
            }
        }.resume()
    }
    
    func logout() {
        self.user = nil
        self.isLoggedin = false
    }
}
