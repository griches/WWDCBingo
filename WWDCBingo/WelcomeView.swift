import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Spacer()
                
                // App Icon/Logo Area
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.rectangle.stack.fill")
                        .font(.system(size: 100))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .blue.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .symbolEffect(.bounce, value: 1)
                    
                    // App Title
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Text("WWDC")
                                .font(.largeTitle)
                                .fontWeight(.black)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .blue.opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text("2025")
                                .font(.largeTitle)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                        }
                        
                        Text("Bingo")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .tracking(2)
                    }
                }
                
                // Subtitle
                VStack(spacing: 8) {
                    Text("Interactive Keynote Companion")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("Tap squares as WWDC moments happen during the keynote!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Start Game Button
                NavigationLink(destination: GameView()) {
                    HStack(spacing: 10) {
                        Image(systemName: "play.fill")
                            .font(.title3)
                        
                        Text("Start New Game")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .blue.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .padding(.horizontal, 20)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Secondary Info
                VStack(spacing: 8) {
                    Text("Made for WWDC 2025")
                        .font(.caption)
                        .foregroundColor(.secondary.opacity(0.7))
                    
                    Text("Version 1.0")
                        .font(.caption2)
                        .foregroundColor(.secondary.opacity(0.5))
                }
                
                Spacer(minLength: 20)
            }
            .padding()
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    WelcomeView()
} 