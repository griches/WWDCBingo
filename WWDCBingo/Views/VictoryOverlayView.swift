import SwiftUI

struct VictoryOverlayView: View {
    let winningPatterns: [WinningPattern]
    let onNewGame: () -> Void
    let onContinue: () -> Void
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    onContinue()
                }
            
            // Victory card
            VStack(spacing: 20) {
                // Victory emoji and text
                VStack(spacing: 12) {
                    Text("🎉")
                        .font(.system(size: 60))
                        .scaleEffect(scale)
                    
                    Text("BINGO!")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                    
                    Text(victoryMessage)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Action button (only Keep Playing)
                Button(action: onContinue) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Keep Playing")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .cyan]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal, 40)
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.bouncy(duration: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
    
    private var victoryMessage: String {
        if winningPatterns.count == 1 {
            return "You got a \(winningPatterns.first?.type.displayName ?? "bingo")!"
        } else {
            let types = winningPatterns.map { $0.type.displayName }
            return "Amazing! You got \(types.joined(separator: " & "))!"
        }
    }
}

#Preview("Single Win") {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        VictoryOverlayView(
            winningPatterns: [
                WinningPattern(
                    type: .horizontal(row: 0),
                    positions: [
                        GridPosition(row: 0, column: 0),
                        GridPosition(row: 0, column: 1),
                        GridPosition(row: 0, column: 2),
                        GridPosition(row: 0, column: 3),
                        GridPosition(row: 0, column: 4)
                    ]
                )
            ],
            onNewGame: {},
            onContinue: {}
        )
    }
}

#Preview("Multiple Wins") {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        VictoryOverlayView(
            winningPatterns: [
                WinningPattern(
                    type: .horizontal(row: 0),
                    positions: [
                        GridPosition(row: 0, column: 0),
                        GridPosition(row: 0, column: 1),
                        GridPosition(row: 0, column: 2),
                        GridPosition(row: 0, column: 3),
                        GridPosition(row: 0, column: 4)
                    ]
                ),
                WinningPattern(
                    type: .vertical(column: 2),
                    positions: [
                        GridPosition(row: 0, column: 2),
                        GridPosition(row: 1, column: 2),
                        GridPosition(row: 2, column: 2),
                        GridPosition(row: 3, column: 2),
                        GridPosition(row: 4, column: 2)
                    ]
                )
            ],
            onNewGame: {},
            onContinue: {}
        )
    }
} 