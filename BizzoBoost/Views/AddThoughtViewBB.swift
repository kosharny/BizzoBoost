import SwiftUI

struct AddThoughtViewBB: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ViewModelBB
    
    @State private var thoughtText: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                viewModel.currentTheme.backgroundGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("New Thought")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ZStack(alignment: .topLeading) {
                                if thoughtText.isEmpty {
                                    Text("What's on your mind?")
                                        .foregroundColor(.white.opacity(0.5))
                                        .padding(.horizontal, 28)
                                        .padding(.vertical, 16)
                                }
                                TextEditor(text: $thoughtText)
                                    .frame(height: 150)
                                    .padding(8)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.white.opacity(0.1))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.horizontal)
                            }
                        }
                        
                        Button {
                            saveThought()
                        } label: {
                            Text("Save Thought")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(thoughtText.isEmpty ? Color.gray.opacity(0.5) : ThemeBB.neonMint)
                                .foregroundColor(thoughtText.isEmpty ? .white : ThemeBB.primaryIndigo)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: thoughtText.isEmpty ? .clear : ThemeBB.neonMint.opacity(0.5), radius: 10)
                        }
                        .disabled(thoughtText.isEmpty)
                        .padding(.horizontal)

                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
            }
            .dismissKeyboardOnTap()
            .navigationTitle("Add to Journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
    
    private func saveThought() {
        let newThought = GoalModelBB(
            title: "Journal Entry",
            category: "Thoughts",
            date: Date(),
            isCompleted: true,
            points: 0,
            note: thoughtText,
            photoData: nil
        )
        viewModel.goals.append(newThought)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddThoughtViewBB().environmentObject(ViewModelBB())
}
