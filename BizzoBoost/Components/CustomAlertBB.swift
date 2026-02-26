import SwiftUI

struct CustomAlertButtonBB {
    let title: String
    var isPrimary: Bool = false
    let action: () -> Void
}

struct CustomAlertBB {
    let title: String
    let message: String
    let primaryButton: CustomAlertButtonBB
    let secondaryButton: CustomAlertButtonBB?
}

struct CustomAlertModifierBB: ViewModifier {
    @Binding var isPresented: Bool
    let alert: CustomAlertBB

    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                
                VStack(spacing: 20) {
                    Text(alert.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(alert.message)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        Button {
                            withAnimation {
                                isPresented = false
                            }
                            alert.primaryButton.action()
                        } label: {
                            Text(alert.primaryButton.title)
                                .font(.headline)
                                .foregroundColor(alert.primaryButton.isPrimary ? ThemeBB.primaryIndigo : .white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(alert.primaryButton.isPrimary ? ThemeBB.neonMint : Color.white.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        if let secondaryBtn = alert.secondaryButton {
                            Button {
                                withAnimation {
                                    isPresented = false
                                }
                                secondaryBtn.action()
                            } label: {
                                Text(secondaryBtn.title)
                                    .font(.headline)
                                    .foregroundColor(secondaryBtn.isPrimary ? ThemeBB.primaryIndigo : .white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(secondaryBtn.isPrimary ? ThemeBB.neonMint : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(secondaryBtn.isPrimary ? .clear : .white.opacity(0.2), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: .black.opacity(0.3), radius: 20)
                .padding(40)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

extension View {
    func customAlertBB(isPresented: Binding<Bool>, alert: CustomAlertBB) -> some View {
        self.modifier(CustomAlertModifierBB(isPresented: isPresented, alert: alert))
    }
}
