import SwiftUI

struct ChoiceView: View {
    
    @StateObject var model: PlantViewModel = PlantViewModel.shared
    @StateObject var router: Router = Router.shared
    @State var chosen: [PlantModel] = [PlantModel]()
    @State var type: TypeOfCaring = .watering
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Background()
            VStack(spacing: 12) {
                
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
                    Button {
                        if chosen.count > 0 {
                            chosen = [PlantModel]()
                        }
                    } label: {
                        let text = chosen.count > 0 ? "Отмена" : "Выбрать"
                        AtypText(text, size: 18)
                            .padding(.vertical, 9)
                            .padding(.horizontal, 18)
                            .background(Color("GrayInactive"))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                }
                .padding(.top, 23)
                
                ScrollView {
                    let columns = Array(repeating: GridItem(.flexible()), count: 3)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(model.plants, id: \.id) { plant in
                            VStack(alignment: .leading, spacing: 5) {
                                PlantChoiceView(plant: plant, type: type)
                                    .overlay(alignment: .bottomTrailing) {
                                        if chosen.contains(where: { pl in
                                            pl.id == plant.id
                                        }) {
                                            Image(systemName: "checkmark.square.fill")
                                                .font(.system(size: 36))
                                                .foregroundColor(.white)
                                                .background(Color.black.frame(width: 25, height: 25))
                                                .padding([.bottom, .trailing], 5)
                                        }
                                    }
                                AtypText(plant.name, size: 14)
                                Spacer()
                            }
                            .frame(width: 116)
                            .onTapGesture {
                                if let ind = chosen.firstIndex(where: { pl in
                                    pl.id == plant.id
                                }) {
                                    chosen.remove(at: ind)
                                } else {
                                    chosen.append(plant)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 13)
            
            LinearGradient(colors:  [.clear, Color("GrayGradient").opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .frame(height: 138)
            Button {
                router.showSetup(plants: chosen, type: type)
            } label: {
                HStack(spacing: 5) {
                    AtypText("Далее", size: 16)
                        .padding(.horizontal, 16)
                        .frame(height: 58)
                        .cornerRadius(29)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 16)
                .frame(width: 136, height: 58)
                .background(Color("Tabbar"))
                .cornerRadius(29)
            }
        }
        .onDisappear {
            chosen = [PlantModel]()
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
                        AtypText("назад к календарю", size: 20)
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}


enum TypeOfCaring: String {
    case watering = "полив"
    case fertilizer = "удобрение"
}
