import Foundation

struct PostModel: Codable {
    let name: String
    let description: String
    let image: Data?
}


struct PostResponse: Codable {
    let plants: [PostModel]
}


class Networking {
    
    static let shared: Networking = Networking()
    
    var baseURLString = "http://localhost:3000"
    var getRequest = "plants"
    var postRequest = ""
    
    var url: String {
        return baseURLString + "/api/v1/" + getRequest
    }
    
    func getPosts(completion: @escaping ([PostModel]) -> ()) {
        
        guard let url =  URL(string: self.url) else {
            return
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("ERROR API: \(error)")
            } else {
                let decoder = JSONDecoder()
                
                do {
                    let postResponse = try decoder.decode(PostResponse.self, from: data!)
                    let plants = postResponse.plants
                    DispatchQueue.main.async {
                        completion(plants)
                    }
                } catch {
                    print("ERROR DECODING: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func uploadPosts(plants: [PostModel]) {
        guard let url = URL(string: baseURLString + "/api/v1/" + postRequest) else {
            return
        }
        let response = PostResponse(plants: plants)
        let encoder = JSONEncoder()
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(response)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("ERROR API: \(error)")
            } else {
                print("success")
            }
        }
        task.resume()
    }
}

