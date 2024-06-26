import SwiftUI

struct SetUpPlantView: View {
    
    @StateObject var model: PlantViewModel = PlantViewModel.shared
    @StateObject var router: Router = Router.shared
    @State var selected: String = "пусто"
    @State var plants: [PlantModel]
    var type: TypeOfCaring
    let vars: [String] = [
        "пусто", "день", "2 дня",
        "3 дня", "4 дня", "5 дней",
        "6 дней", "7 дней"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Background()
            VStack(spacing: 25) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(plants, id: \.id) { plant in
                            ZStack(alignment: .topLeading) {
                                PlantChoiceView(plant: plant, type: type)
                                    .padding([.top, .leading], 6)
                                Button {
                                    if let ind = plants.firstIndex(where: { pl in
                                        pl.id == plant.id
                                    }) {
                                        plants.remove(at: ind)
                                    }
                                    if plants.count == 0 {
                                        router.back()
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color("GrayXmark"))
                                        .background(Circle().fill(.white).frame(width: 15))
                                }
                            }
                        }
                    }
                }
                VStack(alignment: .leading) {
                    AtypText("Каждый(е)", size: 22)
                        .padding([.top, .leading], 17)
                    Picker("damn", selection: $selected) {
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
                    AtypText(Date().dateAsString, size: 22)
                }
                .padding(16)
                .background(.white)
                .frame(height: 54)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding(.top, 23)
            .padding(.horizontal, 14)
            
            
            Button {
                plants.forEach { plant in
                    var pl: PlantModel = plant
                    let ind = vars.firstIndex(where: { v in
                        v == selected
                    })
                    switch type {
                    case .watering:
                        pl.watering = ind == 0 ? nil : ind
                        pl.wateringDate = Date()
                    case .fertilizer:
                        pl.fertilizer = ind == 0 ? nil : ind
                        pl.fertilizerDate = Date()
                    }
                    model.patchPlant(pl)
                }
                router.backToRoot()
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
                    router.back()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                        AtypText("назад", size: 20)
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}
