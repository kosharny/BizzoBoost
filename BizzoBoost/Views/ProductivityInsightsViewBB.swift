import SwiftUI

struct ProductivityInsightsViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @Environment(\.presentationMode) var presentationMode
    
    @State private var appearAnimation = false
    
    var body: some View {
        ZStack {
            VolumetricBackgroundBB(theme: viewModel.currentTheme)
                .ignoresSafeArea()
            GameParticleBackgroundBB(theme: viewModel.currentTheme)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Focus Insights")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // Hero Graphic
                        ZStack {
                            Circle()
                                .fill(ThemeBB.primaryGradient)
                                .frame(width: 150, height: 150)
                                .blur(radius: 20)
                                .opacity(appearAnimation ? 0.6 : 0)
                            
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                                .shadow(color: ThemeBB.neonMint, radius: appearAnimation ? 15 : 0)
                                .scaleEffect(appearAnimation ? 1.0 : 0.8)
                        }
                        .padding(.top, 20)
                        
                        Text("Your Productivity DNA")
                            .font(.headline)
                            .foregroundColor(ThemeBB.premiumGold)
                            .opacity(appearAnimation ? 1.0 : 0)
                        
                        // Stats Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            insightCard(title: "Peak Energy", value: "Morning", icon: "sun.max.fill", color: .orange, delay: 0.1)
                            insightCard(title: "Focus Score", value: "87%", icon: "target", color: ThemeBB.neonMint, delay: 0.2)
                            insightCard(title: "Consistency", value: "High", icon: "chart.line.uptrend.xyaxis", color: ThemeBB.electricBlue, delay: 0.3)
                            insightCard(title: "Endurance", value: "\(viewModel.streak) Days", icon: "flame.fill", color: .red, delay: 0.4)
                        }
                        .padding(.horizontal)
                        
                        // Deep Dive Text
                        VStack(alignment: .leading, spacing: 12) {
                            Text("AI Analysis")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Your habit patterns show strong momentum in the morning hours. Capitalize on this by scheduling your most difficult tasks before noon. Your focus score is in the top 15% of users!")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(6)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(ThemeBB.primaryIndigo.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .opacity(appearAnimation ? 1.0 : 0)
                        .offset(y: appearAnimation ? 0 : 20)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                appearAnimation = true
            }
        }
    }
    
    @ViewBuilder
    func insightCard(title: String, value: String, icon: String, color: Color, delay: Double) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .opacity(appearAnimation ? 1.0 : 0)
        .offset(y: appearAnimation ? 0 : 20)
        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay), value: appearAnimation)
    }
}

#Preview {
    ProductivityInsightsViewBB().environmentObject(ViewModelBB())
}
