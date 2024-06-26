import SwiftUI

struct ChangePlantView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var model: PlantViewModel = PlantViewModel.shared
    @Binding var plant: PlantModel
    @State var selected: String = "пусто"
    @State var type: TypeOfCaring = .watering
    let vars: [String] = [
        "пусто", "день", "2 дня",
        "3 дня", "4 дня", "5 дней",
        "6 дней", "7 дней"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Background()
            
            VStack(alignment: .leading) {
                
                HStack(alignment: .top) {
                    PlantImage(image: plant.image, color: .white)
                        .frame(width: 118, height: 118)
                        .cornerRadius(4)
                    PrettyText(plant.name.uppercased(), size: 38)
                }
                
                HStack {
                    AtypText("полив", size: 18)
                        .padding(.vertical, 9)
                        .padding(.horizontal, 18)
                        .background(type == .watering ? .black : .white)
                        .foregroundColor(type == .watering ? .white : .black)
                        .cornerRadius(10)
                        .onTapGesture {
                            type = .watering
                        }
                    AtypText("удобрение", size: 18)
                        .padding(.vertical, 9)
                        .padding(.horizontal, 18)
                        .background(type == .fertilizer ? .black : .white)
                        .foregroundColor(type == .fertilizer ? .white : .black)
                        .cornerRadius(10)
                        .onTapGesture {
                            type = .fertilizer
                        }
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    AtypText("Каждый(е)", size: 22)
                        .padding([.top, .leading], 17)
                    Picker("damn2", selection: $selected) {
                        ForEach(vars, id: \.self) { val in
                            AtypText(val, size: 22)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                .background(.white)
                .cornerRadius(10)
                
                HStack {
                    AtypText("Начальная дата:", size: 22)
                    Spacer()
                    let date = (type == .watering ? plant.wateringDate : plant.fertilizerDate) ?? Date()
                    AtypText(date.dateAsString, size: 22)
                }
                .padding(16)
                .background(.white)
                .frame(height: 54)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding(.top, 32)
            .padding(.horizontal, 13)
            
            Button {
                var pl: PlantModel = plant
                let ind = vars.firstIndex(where: { v in
                    v == selected
                })
                switch type {
                case .watering:
                    pl.watering = ind == 0 ? nil : ind
                    if pl.wateringDate == nil {
                        pl.wateringDate = Date()
                    }
                case .fertilizer:
                    pl.fertilizer = ind == 0 ? nil : ind
                    if pl.fertilizerDate == nil {
                        pl.fertilizerDate = Date()
                    }
                }
                plant = pl
                model.patchPlant(pl)
                dismiss()
            } label: {
                HStack {
                    AtypText("Готово!", size: 16)
                        .padding(.horizontal, 16)
                        .frame(height: 58)
                        .cornerRadius(29)
                }
                .frame(width: 136, height: 58)
                .background(Color("Tabbar"))
                .cornerRadius(29)
                .foregroundColor(.black)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        AtypText("назад к выбору", size: 20)
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}
