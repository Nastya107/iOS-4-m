import SwiftUI

final class Router: ObservableObject {
    static let shared = Router()

    @Published var path = [Route]()
    
    func showNotifications(plants: [PlantModel], today: Date) {
        path.append(.notifications(plants, today))
    }

    func showChoice() {
        path.append(.choice)
    }
    
    func showSetup(plants: [PlantModel], type: TypeOfCaring) {
        path.append(.setup(plants, type))
    }
    
    func backToRoot() {
        path.removeAll()
    }
    
    func back() {
        path.removeLast()
    }
}

enum Route: Hashable {    
    case notifications([PlantModel], Date)
    case choice
    case setup([PlantModel], TypeOfCaring)
    
}
