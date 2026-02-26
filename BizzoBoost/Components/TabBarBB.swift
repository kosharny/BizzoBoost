import SwiftUI

struct TabBarBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @Namespace private var animation

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabBB.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.activeTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.rawValue)
                            .font(.system(size: 24))
                            .foregroundColor(viewModel.activeTab == tab ? ThemeBB.neonMint : .white.opacity(0.5))
                            .scaleEffect(viewModel.activeTab == tab ? 1.2 : 1.0)
                            .shadow(color: viewModel.activeTab == tab ? ThemeBB.neonMint.opacity(0.8) : .clear, radius: 12)
                            .background {
                                if viewModel.activeTab == tab {
                                    Circle()
                                        .fill(ThemeBB.neonMint.opacity(0.2))
                                        .frame(width: 55, height: 55)
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                }
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 18)
        .background {
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    TabBarBB().environmentObject(ViewModelBB())
}
