import SwiftUI

struct PopularGoalsInfoViewBB: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ViewModelBB
    
    // Mock Infographic Data
    let goalStats = [
        ("Read 10 Pages", "24%"),
        ("Drink Water", "19%"),
        ("Exercise", "15%"),
        ("Meditate", "12%"),
        ("Journal", "8%"),
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                VolumetricBackgroundBB(theme: viewModel.currentTheme)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        Image(systemName: "chart.bar.xaxis")
                            .font(.system(size: 60))
                            .foregroundColor(ThemeBB.premiumGold)
                            .padding(.top, 20)
                        
                        Text("Global Goal Trends")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("A look at the most popular daily goals successfully tracked by users this year.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 30)
                        
                        VStack(spacing: 16) {
                            ForEach(Array(goalStats.enumerated()), id: \.offset) { index, stat in
                                HStack {
                                    Text("\(index + 1)")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(index < 3 ? ThemeBB.premiumGold : .white.opacity(0.5))
                                        .frame(width: 30)
                                    
                                    Text(stat.0)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text(stat.1)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(ThemeBB.neonMint)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(ThemeBB.neonMint.opacity(0.2))
                                        .clipShape(Capsule())
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(ThemeBB.primaryIndigo.opacity(0.6))
                                        .shadow(color: .black.opacity(0.2), radius: 5, y: 2)
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(ThemeBB.premiumGold)
                                Text("Fun Fact")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            Text("Users who track exactly 3 goals daily are 40% more likely to maintain a month-long streak compared to those who track 5 or more.")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .background(ThemeBB.primaryIndigo.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(ThemeBB.premiumGold.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ThemeBB.neonMint)
                }
            }
        }
    }
}

#Preview {
    PopularGoalsInfoViewBB().environmentObject(ViewModelBB())
}
