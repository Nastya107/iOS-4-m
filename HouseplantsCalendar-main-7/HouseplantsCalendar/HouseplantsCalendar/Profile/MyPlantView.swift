import SwiftUI

struct MyPlantView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var model: PlantViewModel = PlantViewModel.shared
    @State var plant: PlantModel
    
    var body: some View {
        ZStack {
            Background()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    PlantImage(image: plant.image, color: .white)
                        .frame(height: 364)
                        .cornerRadius(14)
                    PrettyText(plant.name.uppercased(), size: 38)
                    AtypText(plant.description, size: 22)
                        .padding(9)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white)
                        .cornerRadius(14)
                    HStack {
                        AtypText("Расписание ухода", size: 24)
                        NavigationLink {
                            ChangePlantView(plant: $plant)
                        } label: {
                            Image("Pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                        }
                        Spacer()
                    }
                    HStack {
                        HStack(spacing: 4) {
                            let text = plant.watering != nil ? "каждые \(plant.watering!) дней" : "нет полива"
                            Image(systemName: "drop.fill")
                                .font(.system(size: 16))
                            AtypText(text, size: 16)
                        }
                        .padding(8)
                        .background(.white)
                        .cornerRadius(10)

                        HStack(spacing: 4) {
                            let text = plant.fertilizer != nil ? "каждые \(plant.fertilizer!) дней" : "нет удобрения"
                            Image("Fertilizer")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16)
                            AtypText(text, size: 16)
                        }
                        .padding(8)
                        .background(.white)
                        .cornerRadius(10)
                        
                        Spacer()
                    }
                    
                    PrettyButton(label: "Удалить растение") {
                        model.deletePlant(plant)
                        dismiss()
                    }
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, 13)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    CreatePlantView(flag: false, plant: plant)
                } label: {
                    Image("Pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
            }
        }
    }
}
