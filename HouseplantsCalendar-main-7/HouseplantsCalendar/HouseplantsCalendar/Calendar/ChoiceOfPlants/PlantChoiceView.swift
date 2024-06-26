import SwiftUI

struct PlantChoiceView: View {
    var plant: PlantModel
    var type: TypeOfCaring
    
    var body: some View {
        ZStack(alignment: .top) {
            PlantImage(image: plant.image, color: .gray)
                .cornerRadius(10)
                .frame(width: 116, height: 116)
            Color.white
                .cornerRadius(6)
                .frame(width: 105, height: 18)
                .overlay {
                    info()
                }
                .padding(.top, 3)
            
        }
    }
    
    @ViewBuilder
    func info() -> some View {
        switch type {
        case .watering:
            if let watering = plant.watering {
                AtypText("1 раз/\(watering) дней", size: 12)
            } else {
                AtypText("нет полива", size: 12)
            }
        case .fertilizer:
            if let fertilizer = plant.fertilizer {
                AtypText("1 раз/\(fertilizer) дней", size: 12)
            } else {
                AtypText("нет удобрения", size: 12)
            }
        }
    }
    
}
