import SwiftUI

struct GameView: View {
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 8) {
                Text("WWDC 2025 Bingo")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Game will appear here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Placeholder Content
            VStack(spacing: 20) {
                Image(systemName: "square.grid.3x3")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue.gradient.opacity(0.3))
                
                Text("Bingo Grid Coming Soon!")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text("The 5x5 bingo grid will be implemented in Task 3")
                    .font(.caption)
                    .foregroundColor(.secondary.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // Back Navigation (temporary)
            Text("← Use back button to return to welcome screen")
                .font(.caption)
                .foregroundColor(.secondary.opacity(0.7))
                .padding()
        }
        .padding()
        .navigationTitle("Bingo Game")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        GameView()
    }
} 