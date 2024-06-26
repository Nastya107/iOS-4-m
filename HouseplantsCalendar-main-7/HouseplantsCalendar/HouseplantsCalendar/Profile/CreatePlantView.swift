import SwiftUI
import UIKit
import PhotosUI

struct CreatePlantView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var model: PlantViewModel = PlantViewModel.shared
    @State var image: UIImage?
    @State var name: String
    @State var description: String
    @State var buttonIsActive: Bool
    @State var imageItem: PhotosPickerItem?
    @State var pickerIsPresented: Bool = false
    @State var dialogIsPresented: Bool = false
    @State var oldPlant: PlantModel?
    var createFlag: Bool
    
    init(flag: Bool = true, plant: PlantModel? = nil) {
        self.createFlag = flag
				self._oldPlant = .init(initialValue: plant)
        if let plant {
						self._image = .init(initialValue: plant.image)
						self._name = .init(initialValue: plant.name)
						self._description = .init(initialValue: plant.description)
            self._buttonIsActive = .init(initialValue: true)
        } else {
            self._image = .init(initialValue: nil)
            self._name = .init(initialValue: "")
            self._description = .init(initialValue: "")
            self._buttonIsActive = .init(initialValue: false)
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("Background")
                .ignoresSafeArea()
            
            VStack(spacing: 36) {
                PlantImage(image: image, color: .white)
                    .frame(height: 364)
                    .cornerRadius(14)
                    .confirmationDialog("Select photo", isPresented: $dialogIsPresented) {
                        Button("Camera") { }
                        Button("Gallery") {
                            pickerIsPresented = true
                        }
                        
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Select photo")
                    }
                    .photosPicker(isPresented: $pickerIsPresented, selection: $imageItem, matching: .images)
                    .onChange(of: imageItem) { img in
                        if let img {
                            Task {
                                if let data = try? await img.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    await MainActor.run {
                                        self.image = image
                                    }
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        dialogIsPresented = true
                    }
                
                VStack(alignment: .leading, spacing: 1) {
                    AtypText("Название растения", size: 16)
                    PrettyTextField("Кактус Антон...", text: $name)
                }
                VStack(alignment: .leading, spacing: 1) {
                    AtypText("Описание", size: 16)
                    PrettyTextField("Невероятно красив...", text: $description)
                }
                
                PrettyButton(isActive: $buttonIsActive, label: createFlag ? "Добавить растение" : "Сохранить изменения") {
                    if createFlag {
                        model.addPlant(PlantModel(name: name, image: image, description: description))
                    } else {
                        oldPlant?.image = self.image
                        oldPlant?.name = self.name
                        oldPlant?.description = self.description
                        if let oldPlant {
                            model.patchPlant(oldPlant)
                        }
                    }
                    dismiss()
                }
            }
            .padding(13)
            .onChange(of: [name, description]) { _ in
                checkFields()
            }
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
        }
    }
    
    func checkFields() {
        if image != nil && name.count > 0 && description.count > 0 {
            buttonIsActive = true
        } else {
            buttonIsActive = false
        }
    }
    
}
