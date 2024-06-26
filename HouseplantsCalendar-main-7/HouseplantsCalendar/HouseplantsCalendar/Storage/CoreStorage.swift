import CoreData
import SwiftUI

final class CoreStorage: ObservableObject {
    static let shared = CoreStorage()
    
    let container: NSPersistentContainer
    var corePlants: [CoreModel]
    
    init() {
        container = NSPersistentContainer(name: "CoreModel")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("ERROR: \(error), \(error.userInfo)")
            }
        })
        
        let fetchRequest: NSFetchRequest<CoreModel> = CoreModel.fetchRequest()
        let objects = try? container.viewContext.fetch(fetchRequest)
        self.corePlants = objects ?? [CoreModel]()
    }
    
    func save() {
        try? container.viewContext.save()
    }
    
    func delete(_ plant: PlantModel) {
        if let ind = corePlants.firstIndex(where: { model in
            model.id == plant.id
        }) {
            container.viewContext.delete(corePlants[ind])
            corePlants.remove(at: ind)
            save()
        }
    }
    
    func add(_ plant: PlantModel) {
        let new = CoreModel(context: container.viewContext)
        new.id = plant.id
        new.name = plant.name
        new.image = plant.image
        new.annotation = plant.description
        new.watering = Int64(plant.watering ?? 0)
        new.wateringDate = plant.wateringDate
        new.fertilizer = Int64(plant.fertilizer ?? 0)
        new.fertilizerDate = plant.fertilizerDate
        new.lastWatering = plant.lastWatering
        corePlants.append(new)
        save()
    }
    
    func patch(_ plant: PlantModel) {
        if let old = corePlants.first(where: { model in
            model.id == plant.id
        }) {
            old.name = plant.name
            old.image = plant.image
            old.annotation = plant.description
            old.watering = Int64(plant.watering ?? 0)
            old.wateringDate = plant.wateringDate
            old.fertilizer = Int64(plant.fertilizer ?? 0)
            old.fertilizerDate = plant.fertilizerDate
            old.lastWatering = plant.lastWatering
            save()
        }
    }
}
