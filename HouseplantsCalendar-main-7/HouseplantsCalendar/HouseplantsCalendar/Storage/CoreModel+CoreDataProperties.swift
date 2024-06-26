import UIKit
import CoreData


extension CoreModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreModel> {
        return NSFetchRequest<CoreModel>(entityName: "CoreModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var image: UIImage?
    @NSManaged public var annotation: String?
    @NSManaged public var watering: Int64
    @NSManaged public var wateringDate: Date?
    @NSManaged public var fertilizer: Int64
    @NSManaged public var fertilizerDate: Date?
    @NSManaged public var lastWatering: Date?

}

extension CoreModel : Identifiable {

}
