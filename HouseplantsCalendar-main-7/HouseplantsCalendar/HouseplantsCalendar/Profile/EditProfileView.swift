import SwiftUI
import UIKit
import PhotosUI

struct UserUI {
    var nickname: String
    var avatar: UIImage?
}

struct EditProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @AppStorage("imagedata") var imagedata: Data?
    @AppStorage("nickname") var name: String = "profile_0"
    @State var image: UIImage?
    @State var nickname: String
    @State var imageItem: PhotosPickerItem? = nil
    @State var pickerIsPresented: Bool = false
    @State var dialogIsPresented: Bool = false
    
    init(imagedata: Data?, nickname: String) {
        self._nickname = .init(initialValue: nickname)
        self._image = .init(initialValue: UIImage(data: imagedata ?? Data()))
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
                    AtypText("Ваш никнейм", size: 16)
                    PrettyTextField("никнейм", text: $name)
                }
    
                PrettyButton(label: "Сохранить изменения") {
                    imagedata = image?.pngData() ?? Data()
                    nickname = name
                    dismiss()
                }
            }
            .padding(13)
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
}
