import SwiftUI

struct ProfileView: View {
    
    @AppStorage("imagedata") var imagedata: Data?
    @AppStorage("nickname") var name: String = "profile_0"
    @StateObject var userAuth: UserAuth = UserAuth.shared
    @StateObject var model: PlantViewModel = PlantViewModel.shared
    
    var body: some View {
        ZStack(alignment: .top) {
            Background(height: 72)
            
            VStack(spacing: 22) {
                HStack {
                    if let image = UIImage(data: imagedata ?? Data()) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 46, height: 46)
                            .cornerRadius(23)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(Color("Background"))
                            .font(.system(size: 46))
                    }
                    PrettyText(name.uppercased(), size: 32)
                    NavigationLink {
                        EditProfileView(imagedata: imagedata, nickname: name)
                    } label: {
                        Image("Pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    Spacer()
                }
                PrettyNavigationLink(label: "Добавить растение") {
                    CreatePlantView()
                }
                .padding(.top, 32)
                
                ScrollView {
                    let columns = Array(repeating: GridItem(.flexible()), count: 2)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(model.plants, id: \.id) { plant in
                            NavigationLink {
                                MyPlantView(plant: plant)
                            } label: {
                                VStack(alignment: .leading, spacing: 5) {
                                    PlantImage(image: plant.image, color: .white)
                                        .frame(height: 176)
                                        .cornerRadius(10)
                                    AtypText(plant.name, size: 14)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 13)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    userAuth.logout()
                } label: {
                    HStack {
                        Image(systemName: "arrow.backward.circle")
                            .font(.system(size: 22))
                        AtypText("Выйти", size: 22)
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}


