import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @StateObject private var soundManager = SoundManager.shared
    
    // Grid layout configuration - minimal spacing for maximum tile size
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 5)
    
    var body: some View {
        ZStack {
            // Main game content
            VStack(spacing: 8) {
                // Compact Header
                VStack(spacing: 2) {
                    Text("WWDC 2025 Bingo")
                        .font(.title3) // Smaller title font
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Tap squares as moments happen!")
                        .font(.caption) // Smaller subtitle
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)
                
                // Maximized Bingo Grid
                GeometryReader { geometry in
                    let screenWidth = geometry.size.width
                    let screenHeight = geometry.size.height
                    
                    // Use almost all available width with minimal padding
                    let totalPadding: CGFloat = 16 // Minimal horizontal padding
                    let totalSpacing: CGFloat = 16 // 4 gaps × 4pt spacing
                    let availableWidth = screenWidth - totalPadding
                    let tileSize = (availableWidth - totalSpacing) / 5
                    
                    // Ensure the grid fits in available height, make scrollable if needed
                    let gridHeight = tileSize * 5 + totalSpacing
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Center the grid vertically if there's extra space
                            if gridHeight < screenHeight {
                                Spacer()
                                    .frame(height: max(0, (screenHeight - gridHeight) / 2))
                            }
                            
                            LazyVGrid(columns: columns, spacing: 4) {
                                ForEach(Array(viewModel.tiles.enumerated()), id: \.element.id) { index, tile in
                                    TileView(
                                        text: tile.term,
                                        isSelected: tile.isSelected,
                                        isWinning: viewModel.isWinningTile(at: index)
                                    ) {
                                        viewModel.toggleTile(at: index)
                                    }
                                    .frame(width: tileSize, height: tileSize)
                                }
                            }
                            
                            // Center the grid vertically if there's extra space
                            if gridHeight < screenHeight {
                                Spacer()
                                    .frame(height: max(0, (screenHeight - gridHeight) / 2))
                            }
                        }
                    }
                    .padding(.horizontal, 8) // Minimal horizontal padding
                }
                
                // Compact Game Status with Fixed Height (prevents grid shifting)
                VStack(spacing: 4) {
                    HStack(spacing: 16) {
                        Text(viewModel.gameStatusText)
                            .font(.caption2)
                            .foregroundColor(viewModel.isGameWon ? .green : .secondary)
                            .fontWeight(viewModel.isGameWon ? .bold : .regular)
                        
                        if !viewModel.isGameWon {
                            Text("Find a line, column, or diagonal!")
                                .font(.caption2)
                                .foregroundColor(.secondary.opacity(0.7))
                        }
                    }
                    
                    // Fixed height area for winning pattern details to prevent layout shift
                    Text(viewModel.isGameWon && !viewModel.winningPatterns.isEmpty ? winningPatternsText : "")
                        .font(.caption2)
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                        .opacity(viewModel.isGameWon && !viewModel.winningPatterns.isEmpty ? 1.0 : 0.0)
                }
                .frame(height: 44) // Fixed height to prevent shifting
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 8) // Minimal outer padding
            
            // Confetti Animation Layer
            if viewModel.showConfetti {
                ConfettiView(isActive: viewModel.showConfetti, duration: 3.0)
                    .allowsHitTesting(false)
            }
            
            // Victory Overlay
            if viewModel.showVictoryOverlay {
                VictoryOverlayView(
                    winningPatterns: viewModel.winningPatterns,
                    onNewGame: viewModel.newGameFromVictory,
                    onContinue: viewModel.continueGame
                )
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.3).combined(with: .opacity),
                    removal: .scale(scale: 1.1).combined(with: .opacity)
                ))
                .animation(.bouncy(duration: 0.6), value: viewModel.showVictoryOverlay)
            }
        }
        .navigationTitle("Bingo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                // Sound toggle button
                Button(action: {
                    soundManager.toggleSound()
                }) {
                    Image(systemName: soundManager.isSoundEnabled ? "speaker.2.fill" : "speaker.slash.fill")
                        .foregroundColor(soundManager.isSoundEnabled ? .blue : .gray)
                }
                
                if viewModel.selectedCount > 0 {
                    Button("Reset") {
                        viewModel.resetGame()
                    }
                    .font(.caption)
                    .foregroundColor(.orange)
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var winningPatternsText: String {
        let patterns = viewModel.winningPatterns
        if patterns.count == 1 {
            return patterns.first?.type.displayName ?? ""
        } else {
            let types = patterns.map { $0.type.displayName }
            return types.joined(separator: " & ")
        }
    }
}

#Preview("Default Game") {
    NavigationView {
        GameView()
    }
}

#Preview("Game with Selections") {
    NavigationView {
        GameView()
    }
    .environmentObject(GameViewModel.previewWithSelections)
}

#Preview("Game with Victory") {
    NavigationView {
        GameView()
    }
    .environmentObject(GameViewModel.previewWithVictory)
} 
