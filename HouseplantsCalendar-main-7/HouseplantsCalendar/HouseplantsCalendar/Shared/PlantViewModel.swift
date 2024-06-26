import SwiftUI

class PlantViewModel: ObservableObject {
    
    static let shared: PlantViewModel = PlantViewModel()
    
    @Published var plants: [PlantModel] = [PlantModel]()
    let storage: CoreStorage = CoreStorage.shared
    let net: Networking = Networking.shared
    
    init() {
        net.getPosts { plants in
            self.plants = plants.compactMap { pl in
                return PlantModel(name: pl.name, description: pl.description)
            }
        }
        plants = storage.corePlants.compactMap { pl in
            return PlantModel(id: pl.id ?? UUID(),
                              name: pl.name ?? "",
                              image: pl.image,
                              description: pl.annotation ?? "",
                              watering: Int(pl.watering),
                              wateringDate: pl.wateringDate,
                              fertilizer: Int(pl.fertilizer),
                              fertilizerDate: pl.fertilizerDate,
                              lastWatering: pl.lastWatering)
        }
    }
    
    func uploadPlants() {
        let posts = plants.compactMap { plant in
            return PostModel(name: plant.name, description: plant.description, image: plant.image?.pngData())
        }
        net.uploadPosts(plants: posts)
    }
    
    func addPlant(_ plant: PlantModel) {
        plants.append(plant)
        uploadPlants()
        storage.add(plant)
    }
    
    func deletePlant(_ plant: PlantModel) {
        if let ind = plants.firstIndex(where: { pl in
            pl.id == plant.id
        }) {
            plants.remove(at: ind)
        }
        uploadPlants()
        storage.delete(plant)
    }
    
    func patchPlant(_ plant: PlantModel) {
        if let ind = plants.firstIndex(where: { pl in
            pl.id == plant.id
        }) {
            plants[ind] = plant
        }
        uploadPlants()
        storage.patch(plant)
    }
    
}

