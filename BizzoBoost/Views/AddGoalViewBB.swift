import SwiftUI
import PhotosUI

struct AddGoalViewBB: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ViewModelBB

    @State private var title = ""
    @State private var category = "Habits"
    let categories = ["Sport", "Study", "Habits"]
    
    @State private var note = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        NavigationView {
            ZStack {
                viewModel.currentTheme.backgroundGradient
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    TextField("Goal Title", text: $title)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    HStack {
                        Text("Category")
                            .foregroundColor(.white)
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)

                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { cat in
                            Button {
                                category = cat
                            } label: {
                                Text(cat)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(category == cat ? ThemeBB.neonMint : Color.white.opacity(0.1))
                                    .foregroundColor(category == cat ? ThemeBB.primaryIndigo : .white)
                                    .clipShape(Capsule())
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal)
                        
                        ZStack(alignment: .topLeading) {
                            if note.isEmpty {
                                Text("Optional details...")
                                    .foregroundColor(.white.opacity(0.5))
                                    .padding(.horizontal, 28)
                                    .padding(.vertical, 16)
                            }
                            TextEditor(text: $note)
                                .frame(height: 80)
                                .padding(8)
                                .scrollContentBackground(.hidden)
                                .background(Color.white.opacity(0.1))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal)
                        }
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Photo")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal)
                        
                        if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal)
                        }
                        
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()) {
                                HStack {
                                    Image(systemName: "photo")
                                    Text(selectedImageData == nil ? "Attach Photo" : "Change Photo")
                                }
                                .foregroundColor(ThemeBB.primaryIndigo)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(ThemeBB.neonMint)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal)
                            }
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                    }
                                }
                            }
                    }
                    
                    Spacer()

                    Button {
                        if !title.isEmpty {
                            viewModel.addGoal(title: title, category: category, note: note.isEmpty ? nil : note, photoData: selectedImageData)
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Add Boost")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(title.isEmpty ? Color.gray.opacity(0.5) : ThemeBB.neonMint)
                            .foregroundColor(title.isEmpty ? .white : ThemeBB.primaryIndigo)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: title.isEmpty ? .clear : ThemeBB.neonMint.opacity(0.5), radius: 10)
                    }
                    .disabled(title.isEmpty)
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
                .padding(.top, 32)
            }
            .dismissKeyboardOnTap()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New Goal")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    AddGoalViewBB().environmentObject(ViewModelBB())
}
