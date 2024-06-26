import SwiftUI

struct NotificationCardView: View {
    
    @StateObject var plantModel: PlantViewModel = PlantViewModel.shared
    @State var model: PlantModel
    var today: Date
    let calendar = Calendar.current
    
    var body: some View {
        HStack(spacing: 20) {
            PlantImage(image: model.image)
                .frame(width: 82, height: 82)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                AtypText(model.name, size: 16, true)
                    .lineLimit(0...2)
                Spacer(minLength: 0)
                warning()
                Spacer(minLength: 0)
                if let watering = model.watering {
                    HStack(spacing: 4) {
                        let text = "каждые \(watering) дней"
                        Image(systemName: "drop.fill")
                            .font(.system(size: 16))
                        AtypText(text, size: 16)
                    }
                }
                if let fertilizer = model.fertilizer {
                    HStack(spacing: 4) {
                        let text = "каждые \(fertilizer) дней"
                        Image("Fertilizer")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        AtypText(text, size: 16)
                    }
                }
            }
            Spacer(minLength: 0)
            VStack {
                Spacer()
                Button {
                    model.lastWatering = today
                    plantModel.patchPlant(model)
                } label: {
                    checkmark()
                        .frame(width: 34, height: 34)
                        .cornerRadius(7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .inset(by: 2)
                                .stroke(.gray, lineWidth: 2)
                        )
                }
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: 102)
        .background(.white)
        .cornerRadius(10)
    }
    
    @ViewBuilder
    func warning() -> some View {
        if let last = model.lastWatering,
           let days = model.watering {
            let waiting = calendar.numberOfDaysBetween(last, and: today)
            if waiting > days {
                AtypText("Ожидает полива: \(waiting) дней", size: 12)
                    .foregroundColor(Color("Warning"))
            }
        }
    }
    
    @ViewBuilder
    func checkmark() -> some View {
        if let last = model.lastWatering,
           calendar.numberOfDaysBetween(today, and: last) == 0 {
            Image(systemName: "checkmark")
                .foregroundColor(.black)
        } else {
            Color.clear
        }
    }
}
