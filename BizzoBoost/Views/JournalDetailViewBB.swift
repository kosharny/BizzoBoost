import SwiftUI
import PhotosUI

struct JournalDetailViewBB: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ViewModelBB
    
    var goal: GoalModelBB
    @State private var note: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        NavigationView {
            ZStack {
                viewModel.currentTheme.backgroundGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(goal.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            HStack {
                                Text(goal.category)
                                    .font(.subheadline)
                                    .foregroundColor(ThemeBB.accentGlow)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(ThemeBB.accentGlow.opacity(0.2))
                                    .clipShape(Capsule())
                                Spacer()
                                Text(goal.date, style: .date)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Note")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.horizontal)
                            
                            TextEditor(text: $note)
                                .frame(height: 100)
                                .padding(8)
                                .scrollContentBackground(.hidden)
                                .background(.ultraThinMaterial)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal)
                        }

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Memory Photo")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.horizontal)
                            
                            if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
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

                        Spacer(minLength: 40)
                    }
                    .padding(.vertical)
                }
            }
            .dismissKeyboardOnTap()
            .navigationTitle("Memory")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                note = goal.note ?? ""
                selectedImageData = goal.photoData
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white.opacity(0.8))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let index = viewModel.goals.firstIndex(where: { $0.id == goal.id }) {
                            viewModel.goals[index].note = note.isEmpty ? nil : note
                            viewModel.goals[index].photoData = selectedImageData
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ThemeBB.neonMint)
                    .fontWeight(.bold)
                }
            }
        }
    }
}

#Preview {
    JournalDetailViewBB(goal: GoalModelBB(title: "Morning Run", category: "Sport", date: Date(), isCompleted: true, points: 50))
        .environmentObject(ViewModelBB())
}
