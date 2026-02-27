import SwiftUI

struct HabitTrackerViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @Environment(\.presentationMode) var presentationMode
    @State private var showAddHabit = false
    @State private var newTitle = ""
    @State private var selectedIcon = "star.fill"

    let iconOptions = [
        "star.fill", "heart.fill", "bolt.fill", "book.fill", "drop.fill",
        "figure.walk", "moon.fill", "sun.max.fill", "leaf.fill", "music.note",
        "dumbbell.fill", "brain.head.profile", "fork.knife", "bed.double.fill", "pencil"
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [ThemeBB.primaryIndigo, Color(hex: "#1D2E40")],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button { presentationMode.wrappedValue.dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2).foregroundColor(.white)
                    }
                    Spacer()
                    Text("Daily Habits")
                        .font(.title2).fontWeight(.bold).foregroundColor(.white)
                    Spacer()
                    Button { showAddHabit = true } label: {
                        Image(systemName: "plus")
                            .font(.title2).foregroundColor(ThemeBB.neonMint)
                    }
                }
                .padding()

                if viewModel.habits.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(ThemeBB.neonMint.opacity(0.4))
                        Text("No habits yet")
                            .font(.title3).fontWeight(.semibold).foregroundColor(.white)
                        Text("Tap + to add your first daily habit")
                            .font(.subheadline).foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(viewModel.habits) { habit in
                                habitCard(habit)
                            }
                        }
                        .padding()
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.hideTabBar = true }
        .onDisappear { viewModel.hideTabBar = false }
        .sheet(isPresented: $showAddHabit) {
            addHabitSheet
        }
    }

    @ViewBuilder
    func habitCard(_ habit: HabitModelBB) -> some View {
        let done = habit.isCompletedToday()
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(done ? ThemeBB.neonMint.opacity(0.25) : Color.white.opacity(0.07))
                    .frame(width: 48, height: 48)
                AssetMapBB.habitIcon(for: habit.icon)
                    .frame(width: 32, height: 32)
                    .foregroundColor(done ? ThemeBB.neonMint : .white.opacity(0.7))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(habit.title)
                    .font(.headline)
                    .foregroundColor(done ? .white.opacity(0.6) : .white)
                    .strikethrough(done)

                // 7-day strip
                HStack(spacing: 4) {
                    ForEach(Array(habit.last7Days().enumerated()), id: \.offset) { _, completed in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(completed ? ThemeBB.neonMint : Color.white.opacity(0.1))
                            .frame(width: 14, height: 14)
                    }
                    Text("\(habit.streakCount())d 🔥")
                        .font(.caption2)
                        .foregroundColor(ThemeBB.premiumGold)
                        .padding(.leading, 4)
                }
            }

            Spacer()

            // Check button
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    viewModel.checkOffHabit(id: habit.id)
                }
            } label: {
                Image(systemName: done ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(done ? ThemeBB.neonMint : .white.opacity(0.3))
            }
            .disabled(done)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(done ? ThemeBB.neonMint.opacity(0.4) : Color.clear, lineWidth: 1))
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                viewModel.deleteHabit(id: habit.id)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    var addHabitSheet: some View {
        NavigationView {
            ZStack {
                Color(hex: "#1A1B32").ignoresSafeArea()
                VStack(alignment: .leading, spacing: 24) {
                    Text("New Habit")
                        .font(.title2).fontWeight(.bold).foregroundColor(.white)
                        .padding(.top)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Habit name").font(.caption).foregroundColor(.white.opacity(0.5))
                        TextField("e.g. Drink water", text: $newTitle)
                            .padding()
                            .background(Color.white.opacity(0.07))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Choose icon").font(.caption).foregroundColor(.white.opacity(0.5))
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                            ForEach(iconOptions, id: \.self) { icon in
                                Button {
                                    selectedIcon = icon
                                } label: {
                                    AssetMapBB.habitIcon(for: icon)
                                        .frame(width: 28, height: 28)
                                        .foregroundColor(selectedIcon == icon ? ThemeBB.primaryIndigo : .white)
                                        .frame(width: 44, height: 44)
                                        .background(selectedIcon == icon ? ThemeBB.neonMint : Color.white.opacity(0.07))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                    }

                    Spacer()

                    Button {
                        if !newTitle.trimmingCharacters(in: .whitespaces).isEmpty {
                            viewModel.addHabit(title: newTitle.trimmingCharacters(in: .whitespaces), icon: selectedIcon)
                            newTitle = ""
                            selectedIcon = "star.fill"
                            showAddHabit = false
                        }
                    } label: {
                        Text("Add Habit")
                            .font(.headline).fontWeight(.bold)
                            .foregroundColor(ThemeBB.primaryIndigo)
                            .frame(maxWidth: .infinity).padding()
                            .background(ThemeBB.neonMint)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HabitTrackerViewBB().environmentObject(ViewModelBB())
}
