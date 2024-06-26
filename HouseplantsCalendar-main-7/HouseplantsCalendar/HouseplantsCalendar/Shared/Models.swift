import UIKit

struct PlantModel: Hashable {
    let id: UUID
    var name: String
    var image: UIImage?
    var description: String
    var watering: Int?
    var wateringDate: Date?
    var fertilizer: Int?
    var fertilizerDate: Date?
    var lastWatering: Date?
    
    init(
        id: UUID = UUID(),
        name: String,
        image: UIImage? = nil,
        description: String,
        watering: Int? = nil,
        wateringDate: Date? = nil,
        fertilizer: Int? = nil,
        fertilizerDate: Date? = nil,
        lastWatering: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.watering = (watering ?? 0) == 0 ? nil : watering
        self.wateringDate = wateringDate
        self.fertilizer = (fertilizer ?? 0) == 0 ? nil : fertilizer
        self.fertilizerDate = fertilizerDate
        self.lastWatering = lastWatering
    }
}

final class DayModel {
    let id: UUID = UUID()
    let date: Date?
    var notifications: [PlantModel]
    
    init(date: Date?, notifications: [PlantModel]) {
        self.date = date
        self.notifications = notifications
    }
}

struct MonthModel {
    let id: UUID = UUID()
    var firstDate: Date
    var dates: [DayModel]
    
    init(_ date: Date) {
        self.firstDate = date.startOfMonth
        
        let startingSpaces = self.firstDate.weekDay
        var dayModelList = Array(repeating: DayModel(date: nil, notifications: [PlantModel]()), count: startingSpaces)
        
        let dates = date.getAllDates().compactMap { day in
            return DayModel(date: day, notifications: [PlantModel]())
        }
        
        dayModelList.append(contentsOf: dates)
        self.dates = dayModelList
    }
}
